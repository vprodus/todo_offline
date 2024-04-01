defmodule TodoOfflineWeb.HomeHTML do
  use TodoOfflineWeb, :html

  def index(assigns) do
    ~H"""
    <.AppInfo showAuthLinks />
    """
  end
end
