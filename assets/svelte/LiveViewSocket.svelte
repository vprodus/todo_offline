<script lang="ts">
  import { liveView, serverDocument } from "$stores/liveViewSocket";

  import type { Live } from "live_svelte";
  import type { ServerDocument } from "$stores/liveViewSocket";

  // Store 'live' object from live_svelte in a Svelte store.
  export let live: Live;
  $liveView = live;

  // Receive socket assigns from LiveView.
  export let server_document: ServerDocument;

  // Assign socket assigns to reactive stores.
  $: $serverDocument = server_document;
</script>
