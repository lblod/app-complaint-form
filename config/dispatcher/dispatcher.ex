defmodule Dispatcher do
  use Matcher

  define_accept_types [
    html: [ "text/html", "application/xhtml+html" ],
    json: [ "application/json", "application/vnd.api+json" ],
    any: [ "*/*" ]
  ]

  # Helper function to parse the mu-auth header
  defp parse_json_like_header(header_value) do
    try do
      # Parsing logic to find the role names for the expected format:
      # [{"variables":[],"name":"role 1"}, {"variables":[],"name":"role 2"}]
      trimmed_value = String.trim(header_value)
      inner_content = String.slice(trimmed_value, 1, String.length(trimmed_value) - 2)
      role_strings = String.split(inner_content, ",{")

      # Extract the role names
      roles = Enum.map(role_strings, fn role_str ->
        # Use regular expressions to find the name of the role
        regex = ~r/"name":"([^"]+)/
        [_, name] = Regex.run(regex, role_str)
        name
      end)

      {:ok, roles}
    rescue
      e ->
        {:error, "Invalid 'mu-auth-allowed-groups' header format."}
    end
  end

###############################################################################
# Resources
###############################################################################
  get "/accounts/*path", %{ accept: %{ json: true } } do
    forward conn, path, "http://resource/accounts/"
  end

  get "/complaint-forms/*path", %{ accept: %{ json: true } } do
    # Looking for the "admin" role in mu-au-allowed-group header
    allowed_groups_header = Plug.Conn.get_req_header(conn, "mu-auth-allowed-groups")
    case allowed_groups_header do
      [] -> # Header is not present or empty
        send_resp(conn, 403, "{ \"error\": { \"code\": 403, \"message\": \"Forbidden: 'mu-auth-allowed-groups' header missing or empty.\" } }")
      [header_value | _rest] ->
        case parse_json_like_header(header_value) do
          {:ok, role_names} ->
            if "admin" in role_names do
              forward conn, path, "http://resource/complaint-forms/"
            else
              send_resp(conn, 403, "{ \"error\": { \"code\": 403, \"message\": \"Forbidden: Insufficient privileges. 'admin' group required.\" } }")
            end
          {:error, reason} ->
            send_resp(conn, 400, "{ \"error\": { \"code\": 400, \"message\": \"Bad Request: #{reason}\" } }")
        end
    end
  end

  post "/complaint-forms/*path", %{ accept: %{ json: true } } do
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
  #get "/files-download/:id/download", %{ accept: %{ any: true } } do
  #  forward conn, [], "http://file/files/" <> id <> "/download"
  #end
  get "/files-download/:id/download", %{ accept: %{ any: true } } do
    # Looking for the "admin" role in mu-au-allowed-group header
    allowed_groups_header = Plug.Conn.get_req_header(conn, "mu-auth-allowed-groups")
    case allowed_groups_header do
      [] -> # Header is not present or empty
        send_resp(conn, 403, "{ \"error\": { \"code\": 403, \"message\": \"Forbidden: 'mu-auth-allowed-groups' header missing or empty.\" } }")
      [header_value | _rest] ->
        case parse_json_like_header(header_value) do
          {:ok, role_names} ->
            if "admin" in role_names do
              forward conn, [], "http://file/files/" <> id <> "/download"
            else
              send_resp(conn, 403, "{ \"error\": { \"code\": 403, \"message\": \"Forbidden: Insufficient privileges. 'admin' group required.\" } }")
            end
          {:error, reason} ->
            send_resp(conn, 400, "{ \"error\": { \"code\": 400, \"message\": \"Bad Request: #{reason}\" } }")
        end
    end
  end

  # Returns meta data of the uploaded file.
  get "/files/:id", %{ accept: %{ any: true } } do
    # Looking for the "admin" role in mu-au-allowed-group header
    allowed_groups_header = Plug.Conn.get_req_header(conn, "mu-auth-allowed-groups")
    case allowed_groups_header do
      [] -> # Header is not present or empty
        send_resp(conn, 403, "{ \"error\": { \"code\": 403, \"message\": \"Forbidden: 'mu-auth-allowed-groups' header missing or empty.\" } }")
      [header_value | _rest] ->
        case parse_json_like_header(header_value) do
          {:ok, role_names} ->
            if "admin" in role_names do
              forward conn, [], "http://resource/files/" <> id
            else
              send_resp(conn, 403, "{ \"error\": { \"code\": 403, \"message\": \"Forbidden: Insufficient privileges. 'admin' group required.\" } }")
            end
          {:error, reason} ->
            send_resp(conn, 400, "{ \"error\": { \"code\": 400, \"message\": \"Bad Request: #{reason}\" } }")
        end
    end
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

  # We handle the old download links in the frontend now.
  get "/files/:id/download", %{ accept: %{ any: true } } do
    forward conn, [], "http://frontend/index.html"
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
