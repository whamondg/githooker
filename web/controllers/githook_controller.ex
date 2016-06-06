defmodule Githooker.GithookController do
  use Githooker.Web, :controller
  alias Githooker.EventHandler

  def webhook(conn, _params) do
    github_event = List.first(get_req_header(conn, "x-github-event"))
    handleEvent(conn, %{event: github_event})
  end

  def handleEvent(conn, %{event: "deployment"}) do
    json conn, %{ status: "OK", event: "deployment" }
  end

  def handleEvent(conn, %{event: event}) do
    json put_status(conn, 400), %{ status: "Unknown event", event: event }
  end
end

