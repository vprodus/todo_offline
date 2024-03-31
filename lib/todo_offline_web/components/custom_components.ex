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
    <html lang="en" class="[scrollbar-gutter:stable] overflow-y-scroll">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <!-- Favicons -->
        <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png" />
        <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png" />
        <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png" />
        <link rel="manifest" href="/site.webmanifest" />
        <link rel="mask-icon" href="/safari-pinned-tab.svg" color="#5bbad5" />
        <meta name="apple-mobile-web-app-title" content="ToDo" />
        <meta name="application-name" content="ToDo" />
        <meta name="msapplication-TileColor" content="#00aba9" />
        <meta name="theme-color" content="#1d232a" />
        <!-- End Favicons -->
        <meta name="csrf-token" content={Phoenix.Controller.get_csrf_token()} />
        <.live_title suffix=" · ToDo Offline">
          <%= assigns[:page_title] || "ToDo" %>
        </.live_title>
        <meta name="description" content="Local-First LiveView Svelte ToDo App" />
        <!-- Open Graph -->
        <meta property="og:title" content="ToDo" />
        <meta property="og:type" content="website" />
        <meta property="og:url" content="https://liveview-svelte-pwa.fly.dev" />
        <meta property="og:description" content="Local-First LiveView Svelte ToDo App" />
        <meta property="og:locale" content="en_US" />
        <meta property="og:site_name" content="ToDo" />
        <meta property="og:image" content="https://liveview-svelte-pwa.fly.dev/og.png" />
        <meta property="og:image:url" content="https://liveview-svelte-pwa.fly.dev/og.png" />
        <meta property="og:image:alt" content="ToDo app logo" />
        <!-- End Open Graph -->
        <link phx-track-static rel="stylesheet" href={~p"/assets/app.css"} />
        <script defer phx-track-static type="text/javascript" src={~p"/assets/app.js"}>
        </script>
        <script>
          // Set theme in head to avoid FOUC.
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
