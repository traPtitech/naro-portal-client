<template>
  <div class="login">
    <h1>Login</h1>
    <span>ユーザー名：</span>
    <input type="text" v-model="userName" />
    <br />
    <span>パスワード：</span>
    <input type="text" v-model="password" />
    <br />
    <button @click="login">ログイン</button>
  </div>
</template>

<script>
import axios from "axios";
export default {
  name: "login",
  data() {
    return {
      userName: "",
      password: ""
    };
  },
  methods: {
    login() {
      axios.post("/api/login", {
        username: this.userName,
        password: this.password
      });
    }
  }
};
</script>
