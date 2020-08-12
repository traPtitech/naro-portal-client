<template>
  <div id="app">
    <div id="nav">
      <router-link
        :to="{
          name: 'Profile',
          params: { userId: userData.userid }
        }"
        >プロフィール</router-link
      >
      | <router-link :to="{ name: 'Home' }">ホーム</router-link> |
      <router-link :to="{ name: 'Login' }">ログイン</router-link>
    </div>
    <router-view />
  </div>
</template>
<script>
import axios from "axios";
export default {
  data() {
    return {};
  },
  computed: {
    userData() {
      return this.$store.getters.userData;
    }
  },
  mounted() {
    axios.get("/api/whoami").then(res => {
      this.$store.commit("updateUserData", res.data);
    });
  }
};
</script>
<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

#nav {
  padding: 30px;
}

#nav a {
  font-weight: bold;
  color: #2c3e50;
}

#nav a.router-link-exact-active {
  color: #42b983;
}
</style>
