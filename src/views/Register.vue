<template>
  <div>
    <h2>アカウント登録をする</h2>
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
      <button @click="register()">アカウント作成</button>
    </div>
    <p class="response">{{ responseMessage }}</p>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "Register",
  data() {
    return {
      responseMessage: "",
      username: "",
      password: ""
    };
  },
  methods: {
    register() {
      if (this.username == "" || this.password == "") {
        this.responseMessage = "フィールドが空です。";
        return;
      }
      if (this.username.length > 30) {
        this.responseMessage = "ユーザー名が長すぎます。（30文字以内）";
        return;
      }
      if (this.password.length < 8 || this.password.length > 32) {
        this.responseMessage = "パスワードの長さが不適切です。（8~32文字）";
        return;
      }

      axios
        .post("/api/register", {
          username: this.username,
          password: this.password
        })
        .then(response => {
          if (response.status === 200) {
            this.responseMessage = "Account created! Please login. ✔";
          } else {
            this.responseMessage = "Register failed... ✘";
          }
        })
        .catch(error => {
          this.responseMessage = "Register failed... ✘";
          console.error(error);
        });
    }
  }
};
</script>
