<template>
  <div>
    <div v-if="reviews">
      <div v-for="review in reviews" :key="review.name">
          <div>
              投稿者:
              <router-link :to="'/users/' + review.username">
                {{ review.username }}
              </router-link>
          </div>
          <div>
              タイトル:
              <router-link :to="'/titles/' + review.title">
                {{ review.title }}
              </router-link>
          </div>
          <div>
              感想:{{ review.contents }}
          </div>
          <br>
      </div>
    </div>
    <div v-else>レビューがありません</div>
  </div>
</template>

<script>
import axios from "axios";
export default {
  name: "Myfav",
  data() {
    return {
      reviews: null
    };
  },
  mounted() {
    axios.get('/api/myfav').then(res => {
      this.reviews = res.data;
    }); 
  }
};
</script>