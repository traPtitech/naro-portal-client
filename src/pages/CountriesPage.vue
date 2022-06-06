<script setup>
import axios from "axios";
import { ref, onMounted } from "vue";
const countriesInfo = ref();
onMounted(async () => {
  const res = await axios.get("/api/countries");
  countriesInfo.value = res.data;
});
</script>

<template>
  <div>
    <h1>Countries</h1>
    <div v-if="countriesInfo">
      <div v-for="country in countriesInfo" :key="country.name">
        <router-link :to="`/countries/${country.code}`">
          {{ country.name }}
        </router-link>
      </div>
    </div>
    <div v-else>リストが見つかりませんでした</div>
  </div>
</template>
