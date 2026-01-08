defmodule Dispatcher do
  use Matcher

  define_accept_types [
    html: [ "text/html", "application/xhtml+html" ],
    json: [ "application/json", "application/vnd.api+json" ],
    any: [ "*/*" ]
  ]

  # Helper to parse a json header looking for role names
  defp parse_header(header_value) do
    try do
      # Attempt to extract all "name" fields manually
      matches = Regex.scan(~r/"name"\s*:\s*"([^"]+)"/, header_value)

      role_names = Enum.map(matches, fn [_, name] -> name end)

      {:ok, role_names}
    rescue
      _ ->
        {:error, "Exception during parsing of 'mu-auth-allowed-groups' header."}
    end
  end

  # Helper to determine if we should allow the access to the resource, depending on role
  defp with_role(conn, required_role, on_success) do
    allowed_groups_header = Plug.Conn.get_req_header(conn, "mu-auth-allowed-groups")

    case allowed_groups_header do
      [] ->
        send_resp(conn, 403, "{ \"error\": { \"code\": 403, \"message\": \"Forbidden: 'mu-auth-allowed-groups' header missing or empty.\" } }")

      [header_value | _] ->
        case parse_header(header_value) do
          {:ok, role_names} ->
            if required_role in role_names do
              on_success.()
            else
              send_resp(conn, 403, "{ \"error\": { \"code\": 403, \"message\": \"Forbidden: Insufficient privileges. '#{required_role}' group required.\" } }")
            end

          {:error, reason} ->
            send_resp(conn, 400, "{ \"error\": { \"code\": 400, \"message\": \"Bad Request: #{reason}\" } }")
        end
    end
  end

###############################################################################
# Resources
###############################################################################
  get "/accounts/*path", %{ accept: %{ json: true } } do
    forward conn, path, "http://resource/accounts/"
  end

  get "/complaint-forms/*path", %{ accept: %{ json: true } } do
    with_role(conn, "admin", fn ->
      forward conn, path, "http://resource/complaint-forms/"
    end)
  end

  post "/complaint-forms/*path", %{ accept: %{ json: true } } do
    forward conn, path, "http://resource/complaint-forms/"
  end

  patch "/complaint-forms/*path", %{ accept: %{ json: true } } do
    forward conn, path, "http://resource/complaint-forms/"
  end
###############################################################################
# Sessions
###############################################################################

  match "/mock/sessions/*path" do
    forward conn, path, "http://mocklogin/sessions/"
  end

  match "/sessions/*path" do
    forward conn, path, "http://login/sessions/"
  end

###############################################################################
# Files
###############################################################################

  # We use a different endpoint for the actual downloads since the frontend now handles the regular `GET /files/:id/download` calls.
  get "/files-download/:id/download", %{ accept: %{ any: true } } do
    with_role(conn, "admin", fn ->
      forward conn, [], "http://file/files/" <> id <> "/download"
    end)
  end

  # Returns meta data of the uploaded file.
  get "/files/:id", %{ accept: %{ any: true } } do
    with_role(conn, "admin", fn ->
      forward conn, [], "http://resource/files/" <> id
    end)
  end

  # Endpoint required to upload file content.
  post "/files/*path", %{ accept: %{ any: true } } do
    forward conn, path, "http://file/files/"
  end

###############################################################################
# Frontend
###############################################################################

  match "/index.html", %{ accept: %{ html: true } } do
    forward conn, [], "http://frontend/index.html"
  end

  get "/assets/*path",  %{ accept: %{ any: true } } do
    forward conn, path, "http://frontend/assets/"
  end

  get "/@appuniversum/*path", %{ accept: %{ any: true } } do
    forward conn, path, "http://frontend/@appuniversum/"
  end

  match "/favicon.ico", %{ accept: %{ any: true } } do
    send_resp( conn, 404, "" )
  end

  match "/*_path", %{ accept: %{ html: true } } do
    forward conn, [], "http://frontend/index.html"
  end

###############################################################################
# Fallback
###############################################################################

  match "/*_", %{ last_call: true } do
    send_resp( conn, 404, "{ \"error\": { \"code\": 404, \"message\": \"Route not found. See config/dispatcher.ex\" } }" )
  end

end
