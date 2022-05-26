<template>
  <div>
    <h1>{{ msg }}</h1>
    <Poster />
  </div>
</template>

<script setup>
import Poster from "./PosterComp.vue";

defineProps({
  msg: { type: String, default: "Hello Twiclone" },
});
</script>

<style scoped>
a {
  color: #42b983;
}
</style>
