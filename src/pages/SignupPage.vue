<template>
  <div class="login">
    <h1>This is an signup page</h1>
    <div>
      <input v-model="username" type="text" />
      <input v-model="password" type="password" />
    </div>
    <div>
      <button @click="login">signup</button>
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
    .post("/api/signup", {
      username: username.value,
      password: password.value,
    })
    .then((resopnse) => {
      if (resopnse.status === 201) {
        console.log("signup");
        router.push("/");
      }
    })
    .catch(({ response }) => {
      console.log(response);
      if (response.status === 409) {
        alert("ユーザーが既に存在しています。");
      }
    });
};
</script>
