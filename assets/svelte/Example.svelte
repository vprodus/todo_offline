<script lang="ts">
  import { openedMenuId } from "$stores/clientOnlyState";

  import ThemeManager from "./ThemeManager.svelte";
  import ThemeButton from "./ThemeButton.svelte";
  import ClickOutsideClassHandler from "./ClickOutsideClassHandler.svelte";

  export let number = 1;
  const menuClass = "menu-class";
  let amount: number = 1;
</script>

<ThemeManager />
<ThemeButton {menuClass} />
<ClickOutsideClassHandler
  className={menuClass}
  callbackFunction={() => ($openedMenuId = "")}
/>

<h1 class="flex justify-center mb-10 font-bold">Svelte</h1>

<div class="flex flex-col justify-center items-center gap-4">
  <div class="flex flex-row items-center justify-center gap-10">
    <button class="btn btn-accent" on:click={() => (number -= amount)}
      >-{amount}</button
    >
    <span class="text-xl">{number}</span>
    <button class="btn btn-secondary" on:click={() => (number += amount)}
      >+{amount}</button
    >
  </div>
  <label>
    Amount:
    <input type="number" class="rounded" bind:value={amount} min="1" />
  </label>
</div>
