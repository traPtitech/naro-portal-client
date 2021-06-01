<template>
  <div class="login">
    <h1>This is an login page</h1>
    <div>
        ユーザー名: 
      <input type="text" v-model="username" />
    </div>
    <div>
      パスワード: 
      <input type="password" v-model="password" />
    </div>
    <div>
      <button @click="login">login</button>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import { ref } from 'vue'

export default {
  name: "Login",
  setup() {
    const username = ref('')
    const password = ref('')
    const login = () => axios.post("/api/login", { username: username.value, password: password.value });
    return { username, password, login }
  }
};
</script>