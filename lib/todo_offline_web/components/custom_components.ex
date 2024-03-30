defmodule TodoOfflineWeb.CustomComponents do
  use Phoenix.Component

  use Phoenix.VerifiedRoutes,
    endpoint: TodoOfflineWeb.Endpoint,
    router: TodoOfflineWeb.Router,
    statics: TodoOfflineWeb.static_paths()

  slot :inner_block, required: true

  def root_html(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en" class="[scrollbar-gutter:stable]">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta name="csrf-token" content={Phoenix.Controller.get_csrf_token()} />
        <.live_title suffix=" · Phoenix Framework">
          <%= assigns[:page_title] || "OfflineDemo" %>
        </.live_title>
        <link phx-track-static rel="stylesheet" href={~p"/assets/app.css"} />
        <script defer phx-track-static type="text/javascript" src={~p"/assets/app.js"}>
        </script>
        <script>
          try {
            const theme = JSON.parse(localStorage.getItem("theme"))

            if (["light", "dark"].includes(theme)){
              document.documentElement.setAttribute("data-theme", theme)
            }
          } catch(error) {
            console.log("Ivalid value for 'theme' key in localStorage.", error)
            localStorage.removeItem("theme")
          }
        </script>
      </head>
      <body class="antialiased">
        <%= render_slot(@inner_block) %>
      </body>
    </html>
    """
  end
end
