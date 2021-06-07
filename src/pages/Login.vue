<template>
  <div>
      <div>
        <label>
            username
            <input v-model="username" type="text" />
        </label>
      </div>
      <div>
        <label>
            password
            <input v-model="password" type="password" />
        </label>
      </div>
      <div>
        <button @click="postSignUp">Sign Up</button>
        <button @click="postLogin">Login</button>
      </div>
  </div>
</template>

<script>
import { ref } from "vue"
import axios from "axios";

export default {
  name: "Login",
  setup(){
    const username = ref('')
    const password = ref('')
    const postSignUp = () => axios.post(
        "api/signup",
        {
            username: username.value,
            password: password.value
        }
    )
    const postLogin = () => axios.post(
        "/api/login",
        {
            username: username.value,
            password: password.value
        }
    )
    return {
      username, password,
      postSignUp, postLogin
    }
  },
};
</script>