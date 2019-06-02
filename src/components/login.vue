<template>
  <div id="login">
    <h1>ログイン</h1>
    <p>名前：</p>
    <input type="text" v-model="name" />
    <p>パスワード：</p>
    <input type="password" v-model="password" />
    {{ message }}
    <button v-bind:disabled="isPush" @click="postLogin">ログイン</button>
  </div>
</template>
<script>
import axios from 'axios'
export default {
  name: 'Login',
  data() {
    return {
      name: null,
      password: null,
      message: '',
      isPush: false,
    }
  },
  methods: {
    postLogin() {
      this.isPush = true
      axios
        .post('/api/login', {
          userName: this.name,
          userPassword: this.password,
        })
        .then(res => {
          if (res.data === 'OK') {
            this.$router.push('/timeline')
          } else {
            this.message = '名前またはパスワードが間違っています'
          }
          this.isPush = false
        })
    },
  },
}
</script>
<style>
#login {
  margin-top: 60px;
  text-align: center;
}
</style>
