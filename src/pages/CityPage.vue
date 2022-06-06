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
onMounted(async () => {
  const res = await axios.get("/api/cities/" + props.cityName);
  cityInfo.value = res.data;
});
</script>

<template>
  <div>
    <div v-if="cityInfo">
      <div v-for="city in cityInfo" :key="city.id">
        <h1>
          {{ city.name }}
        </h1>
        <h2>CountryCode</h2>
        <p>{{ city.countryCode }}</p>
        <h2>District</h2>
        <p>{{ city.district }}</p>
        <h2>Population</h2>
        <p>{{ city.population }}</p>
        <h2>ID</h2>
        <p>{{ city.id }}</p>
      </div>
    </div>
    <div v-else>街が見つかりませんでした</div>
  </div>
</template>
