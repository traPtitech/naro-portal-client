<template>
  <div class="login">
    <h1>This is an login page</h1>
    <div>
      <input v-model="username" type="text" />
      <input v-model="password" type="password" />
    </div>
    <div>
      <button @click="login">login</button>
    </div>
  </div>
</template>

<script setup>
import axios from "axios";
import { ref } from "vue";
import router from "../router.js";

const username = ref("");
const password = ref("");

const login = async () => {
  axios
    .post("/api/login", {
      username: username.value,
      password: password.value,
    })
    .then((resopnse) => {
      if (resopnse.status === 200) {
        console.log("login");
        router.push("/");
      }
    });
};
</script>
