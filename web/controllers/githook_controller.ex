defmodule Githooker.GithookController do
  use Githooker.Web, :controller
  alias Githooker.EventHandler

  def webhook(conn, _params) do
    github_event = List.first(get_req_header(conn, "x-github-event"))

    case {github_event} do
       {"deployment"} ->
         json conn, %{ status: "OK", event: github_event } 
       _ ->
         json put_status(conn, 400), %{ status: "Unknown event", event: github_event }
    end
  end
end


