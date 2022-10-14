<script setup>
import axios from "axios";
import { ref } from "vue";

const username = ref("");
const password = ref("");
const login = () =>
  axios.post("/api/login", {
    username: username.value,
    password: password.value,
  });
</script>

<template>
  <div class="login">
    <h1>ログイン</h1>
    <div>
      名前　　　
      <input v-model="username" type="text" />
      <br />
      パスワード
      <input v-model="password" type="password" />
    </div>
    <div>
      <button @click="login">login</button>
    </div>
    <router-link to="/test">または、アカウントを作る</router-link>
  </div>
</template>
