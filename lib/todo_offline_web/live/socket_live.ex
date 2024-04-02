defmodule TodoOfflineWeb.SocketLive do
  @moduledoc """
  This LiveView is embedded inside the AppHTML DeadView and acts as the web
  socket for the Todo application.
  """

  use TodoOfflineWeb, :live_view

  alias TodoOffline.UserData

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      %{id: user_id} = socket.assigns.current_user

      # Subscribe to user document updates.
      UserData.subscribe(user_id)
    end

    socket =
      socket
      |> assign(svelte_opts: %{ssr: false})
      |> assign(server_document: %{"event" => "mount", "document" => nil})

    {:ok, socket, layout: false}
  end

  # Render Component _______________________________________________________________________________

  @impl true
  def render(assigns) do
    ~H"""
    <.LiveViewSocket server_document={@server_document} />
    <!-- Toggle visibility of the sessions badge when the socket is connected/disconnected. -->
    <div
      phx-connected={JS.remove_class("hidden", to: "#sessions-badge")}
      phx-disconnected={JS.add_class("hidden", to: "#sessions-badge")}
    />
    """
  end

  # Event Handlers _________________________________________________________________________________

  @impl true
  # Only allow the client to request the document state after socket is
  # connected to avoid caching user data in service worker cache.
  def handle_event("request_server_document" = event, _params, socket) do
    document = UserData.get_document(socket)
    socket = socket |> assign(server_document: %{"event" => event, "document" => document})

    {:noreply, socket}
  end

  def handle_event("create_server_document" = event, %{"document" => document}, socket) do
    UserData.create_user_document!(%{document: document, user_id: socket.assigns.current_user.id})
    socket = socket |> assign(server_document: %{"event" => event, "document" => document})

    {:reply, %{ok: true}, socket}
  end

  def handle_event("client_document_updated", %{"document" => document}, socket) do
    # Get latest document state by merging Yjs updates.
    latest_document = UserData.get_latest_document(socket, document)

    # Save the latest document to the db and broadcast to all clients.
    # TODO: Handle errors.
    old_user_document = UserData.get_user_document_by_user_id(socket.assigns.current_user.id)
    UserData.update_user_document(old_user_document, %{document: latest_document})

    {:reply, %{ok: true}, socket}
  end

  # Message Handlers _______________________________________________________________________________

  @impl true
  def handle_info({:user_document_updated, user_document}, socket) do
    %{document: document} = user_document

    socket =
      socket
      |> assign(server_document: %{"event" => "user_document_updated", "document" => document})

    {:noreply, socket}
  end
end
