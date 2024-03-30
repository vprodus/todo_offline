defmodule TodoOfflineWeb.HomeController do
  use TodoOfflineWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
