<script setup>
import axios from "axios";
import { ref, onMounted } from "vue";

const username = ref("");
const password = ref("");
const twitterInfo = ref();
const signup = () =>
  axios.post("/api/twitterpost", {
    username: username.value,
    password: password.value,
  });

onMounted(async () => {
  const res = await axios.get("/api/twitter");
  twitterInfo.value = res.data;
});
</script>

<template>
  <div class="login">
    <h1>つぶやこう！</h1>
    <div>
      <input v-model="username" type="text" />
      <br />
      <input v-model="password" type="text" />
    </div>
    <div>
      <button @click="signup">つぶやく！</button>
    </div>
  </div>
  <div>
    <h1>
      {{ "つぶやき一覧" }}
    </h1>
    <div v-if="twitterInfo">
      <span v-for="n in 3" :key="n"
        >{{ n }} {{ twitterInfo[n]["name"]["String"] }}
        {{ twitterInfo[n]["naiyou"]["String"] }}<br
      /></span>
    </div>
    <div v-else></div>
  </div>
</template>
