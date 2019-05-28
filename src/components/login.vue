<template>
  <div>
    <input type="text" v-model="name" />
    <input type="text" v-model="password" />
    <button @click="postLogin">ログイン</button>
  </div>
</template>
<script>
export default {
  name: 'Login',
  data() {
    return {
      name: null,
      password: null,
    }
  },
  methods: {
    postLogin() {
      axios.post('/api/login', {
        userName: this.name,
        userPassword: this.password,
      })
    },
  },
}
</script>
<style></style>
