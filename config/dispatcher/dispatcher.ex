defmodule Dispatcher do
  use Matcher

  define_accept_types [
    any: [ "*/*" ]
  ]

  @any %{ accept: %{ any: true } }

  # Users only create complaint forms.
  post "/complaint-forms/*path", @any do
    forward conn, path, "http://resource/complaint-forms/"
  end

  # This will be protected by basic-auth, so file content will never be public.
  get "/files/:id/download", @any do
    forward conn, [], "http://file/files/" <> id <> "/download"
  end

  # Returns meta data of the uploaded file.
  get "/files/*path", @any do
    forward conn, path, "http://resource/files/"
  end

  # Endpoint required to upload file content.
  post "/file-service/files/*path", @any do
    forward conn, path, "http://file/files/"
  end

  # User must be able to delete file.
  delete "/files/*path", @any do
    forward conn, path, "http://file/files/"
  end

  get "/*_", %{ last_call: true } do
    send_resp( conn, 404, "{ \"error\": { \"code\": 404, \"message\": \"Route not found.  See config/dispatcher.ex\" } }" )
  end

end
