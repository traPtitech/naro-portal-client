<script setup>
import ToDoList from "../components/ToDoList.vue";
</script>

<template>
  <div :class="$style.todolist"><ToDoList /></div>
</template>

<style module>
.todolist {
  padding-top: 3rem;
}
</style>
