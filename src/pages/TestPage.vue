<script setup>
import axios from "axios";
import { ref } from "vue";

const username = ref("");
const password = ref("");
const signup = () =>
  axios.post("/api/signup", {
    username: username.value,
    password: password.value,
  });
</script>

<template>
  <div class="sample">
    <!-- 複数のエラーもv-forで表示する -->
    <p v-for="error in errors" :key="error.id" class="error">{{ error[0] }}</p>
  </div>
  <div class="login">
    <h1>signupページ。</h1>
    <div>
      名前　　　
      <input v-model="username" type="text" />
      <br />パスワード
      <input v-model="password" type="password" />
    </div>
    <div>
      <button @click="signup">signup</button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      keyword: "",
      baths: {},
      errors: {}, // 空のオブジェクトを用意
    };
  },
  methods: {
    searchBath() {
      const url = "/post/search";
      this.errors = ""; // 描画する度にエラーを空にする
      axios
        .post(url, {
          keyword: this.keyword,
        })
        .then((response) => {
          this.baths = response.data;
        })
        // 以下、エラーメッセージの受け取り
        .catch((e) => {
          this.errors = e.response.data.errors;
        });
    },
  },
};
</script>
