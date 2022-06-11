<script setup>
import axios from "axios";
import { ref, onMounted } from "vue";
const twInfo = ref();
const con = ref('');
onMounted(async () => {
  const res = await axios.get("/api/twttt/get");
  twInfo.value = res.data;
});
const post = () => {
  axios.post("/api/twttt/post", {
    "content": con.value
  });
}
</script>

<template>
  <div>
    <div v-if="twInfo">
      <div v-for="value in twInfo">
      </div>
      {{ twInfo }}
      <br/>
      <input v-model="con" type="text" />
      <button @click="post">post</button>
    </div>
    <div v-else>エラーが発生しました</div>
  </div>
</template>