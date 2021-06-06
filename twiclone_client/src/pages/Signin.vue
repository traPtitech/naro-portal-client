<template>
  <div class="login">
    <h1>新規ユーザー登録</h1>
<div>
        ユーザー名: 
      <input type="text" v-model="userid" />
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
    const userid = ref('')
    const password = ref('')
    const signin = () => {
      axios.post("/api/signup", { userid: userid.value, password: password.value })
    };
    return { userid, password, signin }
  }
};
</script>