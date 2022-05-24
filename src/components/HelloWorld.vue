<template>
  <div>
    <h1>{{ msg }}</h1>
    <ClickCounter />
    <ToDoList />
  </div>
</template>

<script setup>
import ClickCounter from "./ClickCounter.vue";
import ToDoList from "./ToDoList.vue";

defineProps({
  msg: { type: String, default: "" },
});
</script>

<style scoped>
a {
  color: #42b983;
}
</style>
