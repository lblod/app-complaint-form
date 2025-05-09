defmodule Dispatcher do
  use Matcher

  define_accept_types [
    html: [ "text/html", "application/xhtml+html" ],
    json: [ "application/json", "application/vnd.api+json" ],
    any: [ "*/*" ]
  ]

###############################################################################
# Resources
###############################################################################

  # Users only create complaint forms.
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

  # This will be protected by basic-auth, so file content will never be public.
  get "/files/:id/download", %{ accept: %{ any: true } } do
    forward conn, [], "http://file/files/" <> id <> "/download"
  end

  # Returns meta data of the uploaded file.
  get "/files/:id", %{ accept: %{ any: true } } do
    forward conn, [], "http://resource/files/" <> id
  end

  # Endpoint required to upload file content.
  post "/files/*path", %{ accept: %{ any: true } } do
    forward conn, path, "http://file/files/"
  end

  # User must be able to delete file.
  delete "/files/*path", %{ accept: %{ any: true } } do
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
