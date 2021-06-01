<template>
  <div class="login">
    <h1>新規ユーザー登録</h1>
<div>
        ユーザー名: 
      <input type="text" v-model="username" />
    </div>
    <div>
      パスワード: 
      <input type="password" v-model="password" />
    </div>
    <div>
      <button @click="signin">signin</button>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import { ref } from 'vue'

export default {
  name: "Signin",
  setup() {
    const username = ref('')
    const password = ref('')
    const signin = () => axios.post("/api/signup", { username: username.value, password: password.value });
    return { username, password, signin }
  }
};
</script>