<script lang="ts" context="module">
  import { indexedDBName } from "./consts";
  import config from "../../priv/static/sw.config";

  import { requestAssetDeletion } from "./ServiceWorker.svelte";

  export function clearUserData() {
    // Clear client storage
    localStorage.clear();
    sessionStorage.clear();

    // Clear private assets cached by service worker
    requestAssetDeletion([...config.privateAssets]);

    // Clear Yjs state storred in indexedDB
    const DBDeleteRequest = window.indexedDB.deleteDatabase(indexedDBName);
    DBDeleteRequest.onerror = () => {
      console.error("Error deleting database");
    };
  }
</script>

<script lang="ts">
  import { onMount } from "svelte";

  import type { Live } from "live_svelte";

  export let live: Live = undefined;
  live;

  onMount(() => {
    clearUserData();
  });
</script>
