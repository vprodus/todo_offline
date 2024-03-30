import "../css/app.scss"

import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import { initTopBar } from "$lib/topbar/initTopBar"
import {getHooks} from "live_svelte"
import * as Components from "../svelte/**/*.svelte"

declare global {
  interface Window {
    liveSocket: LiveSocket;
  }
}

initTopBar();

let csrfToken = document.querySelector("meta[name='csrf-token']")?.getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {hooks: getHooks(Components), params: {_csrf_token: csrfToken}})

liveSocket.connect()

window.liveSocket = liveSocket

liveSocket.getSocket().onOpen(() => {
  fetch(window.location.href, { method: "HEAD" }) // HEAD request to bypass service worker.
    .then((response) => {
      if (response.redirected) {
        window.location.replace(response.url);
      }
    })
    .catch((error) => {
      console.error("error:", error);
    });
});
