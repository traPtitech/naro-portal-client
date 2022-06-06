<script setup>
import axios from "axios";
//import router from "./router.js";
import { useRouter, useRoute } from "vue-router";
const router = useRouter();
const route = useRoute();

const logout = async () => {
  axios.get("/api/logout").then((resopnse) => {
    if (resopnse.status === 200) {
      if (route.fullPath === "/") location.reload();
      else router.push("/");
    }
  });
};
</script>

<template>
  <main>
    <div :class="$style.container">
      <header :class="$style.header">
        <router-link to="/">Home</router-link>
        |
        <router-link to="/toDoList">ToDoList</router-link>
        |
        <router-link to="/countries">Countries</router-link>
        |
        <router-link to="/login">Login</router-link>
        |
        <router-link to="/signup">Signup</router-link>
        |
        <a :class="$style.logout" @click="logout">Logout</a>
      </header>

      <router-view />
    </div>
  </main>
</template>

<style module>
.logout {
  text-decoration: underline;
  color: blue;
  cursor: pointer;
}
a:visited {
  color: purple;
}
.container {
  margin: auto;
  text-align: center;
}
.header {
  display: flex;
  justify-content: center;
  height: 3rem;
}
</style>
