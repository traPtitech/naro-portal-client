<template>
  <div class="login">
    <h1>ログイン</h1>
    <div>
        ユーザー名: 
      <input type="text" v-model="userid" />
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
    const userid = ref('')
    const password = ref('')
    const login = () => {
      axios.post("/api/login", { userid: userid.value, password: password.value })
    };
    return { userid, password, login }
  }
};
</script>