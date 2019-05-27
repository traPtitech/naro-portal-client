<template>
  <div>
    <h2>ログインする</h2>
    <div class="loginForm">
      <label for>
        ユーザー名
        <input type="text" v-model="username" />
      </label>
      <br />
      <label for>
        パスワード
        <input type="password" v-model="password" />
      </label>
      <br />
      <button @click="login()">ログイン</button>
    </div>
    <p class="response">{{ responseMessage }}</p>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "login",
  data() {
    return {
      responseMessage: "",
      username: "",
      password: ""
    };
  },
  methods: {
    login() {
      axios
        .post("/api/login", {
          username: this.username,
          password: this.password
        })
        .then(response => {
          if (response.status === 200) {
            this.responseMessage = "Login success! ✔";
          } else {
            this.responseMessage = "Login failed... ✘";
          }
        })
        .catch(error => {
          this.responseMessage = "Login failed... ✘";
          console.error(error);
        });
    }
  }
};
</script>
