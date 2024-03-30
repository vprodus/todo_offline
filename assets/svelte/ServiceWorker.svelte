<script lang="ts" context="module">
  import messageTypes from "../../priv/static/sw.config";

  export function requestAssetDeletion(assets: string[]) {
    navigator.serviceWorker?.controller?.postMessage({
      type: messageTypes.REQUEST_ASSET_DELETION,
      payload: {
        assets,
      },
    });
  }
</script>
