defmodule TodoOfflineWeb.PageController do
  use TodoOfflineWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, number: 5)
  end
end
