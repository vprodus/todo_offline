defmodule TodoOfflineWeb.AppController do
  use TodoOfflineWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
