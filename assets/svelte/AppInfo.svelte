<script lang="ts" context="module">
  import { init, addMessages, getLocaleFromNavigator } from "svelte-i18n";

  import en from "./locales/en.json";
  import fr from "./locales/fr.json";

  addMessages("en", en);
  addMessages("fr", fr);

  init({
    fallbackLocale: "fr",
    initialLocale: getLocaleFromNavigator(),
  });
</script>

<script lang="ts">
  import { Pane, Splitpanes } from "svelte-splitpanes";
  import { t } from "svelte-i18n";
  import GitHubSvgIcon from "$lib/svg-icons/GitHubSvgIcon.svelte";
  import { openedMenuId } from "$stores/clientOnlyState";

  import ThemeManager from "./ThemeManager.svelte";
  import ThemeChangeMenu from "./ThemeChangeMenu.svelte";
  import ClickOutsideClassHandler from "./ClickOutsideClassHandler.svelte";
  const menuClass = "theme-change";

  import Link from "./Link.svelte";

  import { Live } from "live_svelte";

  export let live: Live = undefined;
  live;

  export let showAuthLinks = false;

  let left_pane_pct = [50];
</script>

<Splitpanes theme="my-theme" style="height: 100vh">
  <Pane bind:size={left_pane_pct[0]} snapSize={20}>
    <div class="overflow-auto hover:overflow-scroll">
      <ThemeManager />
      <ThemeChangeMenu {menuClass} />
      <ClickOutsideClassHandler
        className={menuClass}
        callbackFunction={() => ($openedMenuId = "")}
      />

      <h1 class="text-5xl font-black my-5">
        Local-First LiveView Svelte ToDo App
      </h1>
      <header>
        <h1>{$t("greeting")}</h1>
        <p>{$t("welcome")}</p>
      </header>

      <p>
        This to-do app is a demo of an installable
        <Link href="https://www.phoenixframework.org/" external>Phoenix</Link>
        Progressive Web App (<Link
          href="https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps"
          external
        >
          PWA</Link
        >) that can sync real-time across multiple devices while also being able
        to work locally offline.
      </p>

      <h2 class="text-3xl font-bold my-3">Video Walkthrough</h2>

      <iframe
        class="w-full aspect-video my-6"
        src="https://www.youtube.com/embed/PX9-lq0LL9Q?si=xdd3inTC72OvVV0G"
        title="YouTube video player"
        frameborder="0"
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
        allowfullscreen
      ></iframe>

      <div class="my-6">
        <h2 class="text-3xl font-bold my-3">Technologies used</h2>

        <ul class="list-disc pl-4">
          <li>
            Phoenix
            <Link
              href="https://github.com/phoenixframework/phoenix_live_view"
              external>LiveView</Link
            >,
            <Link
              href="https://hexdocs.pm/phoenix/channels.html#pubsub"
              external>PubSub</Link
            >, and
            <Link
              href="https://github.com/elixir-ecto/ecto/tree/v3.11.1"
              external>Ecto</Link
            >/<Link href="https://www.postgresql.org/" external>PostgreSQL</Link
            > for real-time syncing and data persistence.
          </li>

          <li>
            <Link href="https://svelte.dev/" external>Svelte</Link>
            (via <Link href="https://github.com/woutdp/live_svelte" external
              >live_svelte</Link
            >) for the frontend UI and state management.
          </li>

          <li>
            <Link
              href="https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API"
              external>Service Workers</Link
            >,
            <Link
              href="https://developer.mozilla.org/en-US/docs/Web/API/Web_Storage_API"
              external
            >
              Web Storage</Link
            >, and
            <Link
              href="https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API"
              external
            >
              IndexedDB
            </Link>
            (via <Link href="https://github.com/yjs/y-indexeddb" external
              >y-indexeddb</Link
            >) for offline support.
          </li>

          <li>
            <Link href="https://crdt.tech/" external>CRDTs</Link>
            (via <Link href="https://github.com/yjs/yjs" external>Yjs</Link>) to
            resolve conflicts between distributed app states.
          </li>
        </ul>
      </div>

      <div class="my-6">
        <h2 class="text-3xl font-bold my-3">Inspired by</h2>

        <ul class="list-disc pl-4">
          <li>
            Wout De Puysseleir -
            <Link href="https://www.youtube.com/watch?v=JMkvbW35QvA" external>
              LiveSvelte - Render Svelte directly into Phoenix LiveView with E2E
              reactivity.
            </Link>
          </li>

          <li>
            Ryan Cooke -
            <Link href="https://www.youtube.com/watch?v=asm2TTm035o" external>
              E2E Reactivity - using Svelte with Phoenix LiveView
            </Link>
          </li>

          <li>
            Daniils Petrovs -
            <Link
              href="https://speakerdeck.com/danirukun/svelte-hololive-fan-booth-project"
              external
            >
              SvelteKit: From landing page to offline PWAs
            </Link>
          </li>
        </ul>
      </div>
    </div>
  </Pane>
  {#if showAuthLinks}
    <Pane snapSize={30}>
      <div
        class="p-6 max-w-sm mx-auto bg-white rounded-xl shadow-lg flex space-x-4"
      >
        <h2 class="text-3xl font-bold my-3">Try it out</h2>

        <ul class="flex gap-2">
          <li>
            <a
              href={"/users/register"}
              class="btn btn-accent border border-neutral">Register</a
            >
          </li>
          <li>
            <a
              href={"/users/log_in"}
              class="btn btn-accent border border-neutral">Log in</a
            >
          </li>
        </ul>
      </div>
    </Pane>
  {/if}
</Splitpanes>

<style global lang="scss">
  .splitpanes.my-theme {
    .splitpanes__pane {
      display: flex;
      align-items: center;
      justify-content: center;
      overflow: auto;
      padding: 20px;
    }
    .splitpanes__splitter {
      background-color: #ccc;
      position: relative;
      &:before {
        content: "";
        position: absolute;
        left: 0;
        top: 0;
        transition: opacity 0.4s;
        background-color: rgba(137, 130, 130, 0.3);
        opacity: 0;
        z-index: 1;
      }
      &:hover:before {
        opacity: 1;
      }
      &.splitpanes__splitter__active {
        z-index: 2; /* Fix an issue of overlap fighting with a near hovered splitter */
      }
    }
  }
  .my-theme {
    &.splitpanes--vertical > .splitpanes__splitter:before {
      left: -30px;
      right: -30px;
      height: 100%;
      cursor: col-resize;
    }
    &.splitpanes--horizontal > .splitpanes__splitter:before {
      top: -30px;
      bottom: -30px;
      width: 100%;
      cursor: row-resize;
    }
  }
</style>
