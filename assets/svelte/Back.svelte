<script lang="ts">
  import ArrowLeftSvgIcon from "$lib/svg-icons/ArrowLeftSvgIcon.svelte";
  import { showTopBar } from "$lib/topbar";

  import type { Live } from "live_svelte";

  export let live: Live = undefined;
  live;

  export let href: string = undefined;
  export let ariaLabel = "Back";
  export let showTopBarOnNav = false;
</script>

{#if href}
  <a
    {href}
    aria-label={ariaLabel}
    class="
      flex rounded-lg
      focus:outline-none focus-visible:ring ring-accent ring-offset-1 ring-offset-base-100
    "
  >
    <ArrowLeftSvgIcon className="h-10 w-10" />
  </a>
{:else}
  <button
    aria-label={ariaLabel}
    title={ariaLabel}
    class="
      flex rounded-lg
      focus:outline-none focus-visible:ring ring-accent ring-offset-1 ring-offset-base-100
    "
    on:click={() => {
      if (showTopBarOnNav) {
        showTopBar();
      }

      if (history.length === 1) {
        window.location.replace("/todo");
      } else {
        history.back();
      }
    }}
  >
    <ArrowLeftSvgIcon className="h-10 w-10" />
  </button>
{/if}
