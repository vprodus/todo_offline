defmodule TodoOfflineWeb.AppHTML do
  use TodoOfflineWeb, :html

  def index(assigns) do
    ~H"""
    <!-- LiveView Socket -->
    <%= live_render(@conn, LiveViewSvelteOfflineDemoWeb.SocketLive) %>
    <!-- Svelte App -->
    """
  end
end
