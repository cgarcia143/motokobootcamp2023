<script>
  import logo from ".././assets/camp_logo.png"
  import { onMount } from "svelte";

  onMount(async () => {
  fetch("2g6ts-laaaa-aaaan-qc2mq-cai.app/")
  .then(response => response.json())
  .then(data => {
		console.log(data);
  }).catch(error => {
    console.log(error);
    return [];
  });
});
</script>

<div>
  <header class="App-header">
    <img src={logo} class="App-logo" alt="logo" />
    <p class="slogan">Motoko Bootcamp Dao</p>
    <p class="twitter">← Open me!</p>
  </header>
</div>
