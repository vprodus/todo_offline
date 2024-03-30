defmodule TodoOfflineWeb.HomeHTML do
  use TodoOfflineWeb, :html

  def index(assigns) do
    ~H"""
    <div class="my-10 sm:my-20">
      <.AppInfo showAuthLinks />
    </div>
    """
  end
end
