defmodule Githooker.PageController do
  use Githooker.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
