<script setup>
import axios from "axios";
import { ref } from "vue";

const username = ref("");
const password = ref("");
const signup = () =>
  axios.post("/api/signup", {
    username: username.value,
    password: password.value,
  });
</script>

<template>
  <div class="login">
    <h1>signupページ。</h1>
    <div>
      <input v-model="username" type="text" />
      <br />
      <input v-model="password" type="password" />
    </div>
    <div>
      <button @click="signup">signup</button>
    </div>
  </div>
</template>
