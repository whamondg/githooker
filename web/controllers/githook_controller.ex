defmodule Githooker.GithookController do
  use Githooker.Web, :controller
  alias Githooker.EventHandler
  require Logger

  def webhook(conn, _params) do
    github_event = List.first(get_req_header(conn, "x-github-event"))
    Logger.info "Received GitHub event: #{github_event}"
    handleEvent(conn, %{event: github_event})
  end

  def handleEvent(conn, %{event: "deployment"}) do
    Logger.info "Handling deployment event"
    json conn, %{ status: "OK", event: "deployment" }
  end

  def handleEvent(conn, %{event: event}) do
    Logger.info "Ignoring unknown event: #{event}"
    json put_status(conn, 400), %{ status: "Unknown event", event: event }
  end
end

