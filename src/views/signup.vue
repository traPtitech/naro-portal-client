<template>
  <div>
    <h1>This is an signup page</h1>
    <div>
      <label>
        username
        <input type="text" v-model="username" />
      </label>
      <label>
        password
        <input type="password" v-model="password" />
      </label>
      <button @click="signup">signup</button>
    </div>
  </div>
</template>

<script>
import axios from "axios";
export default {
  name: "signup",
  data() {
    return {
      username: "",
      password: ""
    };
  },
  methods: {
    signup() {
      axios.post("/api/signup", {
        username: this.username,
        password: this.password
      });
    }
  }
};
</script>