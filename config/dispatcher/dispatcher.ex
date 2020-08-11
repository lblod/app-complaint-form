defmodule Dispatcher do
  use Matcher

  define_accept_types [
    any: [ "*/*" ]
  ]

  @any %{ accept: %{ any: true } }

  match "/complaint-forms/*path", @any do
    forward conn, path, "http://resource/complaint-forms/"
  end

  get "/files/:id/download", @any do
    forward conn, [], "http://file/files/" <> id <> "/download"
  end

  get "/files/*path", @any do
    forward conn, path, "http://resource/files/"
  end

  post "/file-service/files/*path", @any do
    forward conn, path, "http://file/files/"
  end

  delete "/files/*path", @any do
    forward conn, path, "http://file/files/"
  end

  match "/file-addresses/*path", @any do
    forward conn, path, "http://resource/file-addresses/"
  end

  get "/*_", %{ last_call: true } do
    send_resp( conn, 404, "{ \"error\": { \"code\": 404, \"message\": \"Route not found.  See config/dispatcher.ex\" } }" )
  end

end
