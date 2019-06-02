<template>
  <div>
    <h1>Welcome!</h1>
    <span>ユーザー名：</span>
    <input type="text" v-model="userName" />
    <br />
    <span>パスワード：</span>
    <input type="text" v-model="password" />
    <br />
    <button @click="signUp">新規登録</button>
  </div>
</template>

<script>
import axios from "axios";
export default {
  name: "signUp",
  methods: {
    signUp() {
      axios.post("/api/signup", {
        username: this.userName,
        password: this.password
      });
    }
  }
};
</script>
