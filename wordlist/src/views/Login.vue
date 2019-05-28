<template>
  <div>
    <h1>Login</h1>
    <input type="text" v-model="userName">
    <input type="text" v-model="password">
    <button @click="login">ログイン</button> 
  </div>
</template>

<script>
export default {
  name: "login",
  methods: {
     login (){
         
     }
  }
};
</script>
