<script setup>
import axios from "axios";
import { ref, onMounted } from "vue";
const props = defineProps({
  cityName: {
    type: String,
    required: true,
  },
});
const cityInfo = ref();
const countryInfo = ref();
onMounted(async () => {
  const res = await axios.get("/api/cities/" + props.cityName);
  cityInfo.value = res.data;
  const res2 = await axios.get("/api/country");
  countryInfo.value = res2.data;
});
</script>

<template>
  <div>
    <h1>
      {{ "国一覧" }}
    </h1>
    <div v-if="cityInfo">{{ cityInfo["name"]["String"][""] }}</div>
    <div v-else>街が見つかりませんでした</div>
    <div v-if="countryInfo">
      <span v-for="n in 238" :key="n"
        ><router-link to="/uradal1"
          >{{ n }} {{ countryInfo[n]["name"]["String"] }} <br /> </router-link
      ></span>
    </div>
    <div v-else>国が見つかりませんでした</div>
    <router-link to="/url1">URL1</router-link>
    <br />
  </div>
</template>
