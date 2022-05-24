<script setup>
import axios from "axios";
import { ref, onMounted } from "vue";
const citiesInfo = ref();
const props = defineProps({
  countryCode: {
    type: String,
    required: true,
  },
});
onMounted(async () => {
  const res = await axios.get(
    "/api/countries/" + props.countryCode + "/cities"
  );
  citiesInfo.value = res.data;
});
</script>

<template>
  <div>
    <h1>City List</h1>
    <div v-if="citiesInfo">
      <div v-for="city in citiesInfo" :key="city.name">
        <router-link :to="`/city/${city.name}`">
          {{ city.name }}
        </router-link>
      </div>
    </div>
    <div v-else>リストが見つかりませんでした</div>
  </div>
</template>
