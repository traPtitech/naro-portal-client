<template>
  <div>
      <div>
          <router-link :to="'/myfav'">お気に入りした投稿</router-link>
      </div>
    <div v-if="reviews">
      <div v-for="review in reviews" :key="review.name">
          <div>
              タイトル:
              <router-link :to="'/titles/' + review.title">
                {{ review.title }}
              </router-link>
          </div>
          <div>
              感想:{{ review.contents }}
          </div>
          <div>
              Fav数:{{ review.favcount }}
          </div>
          <button @click="fav(review.id)">fav</button>
          <br>
          <br>
      </div>
    </div>
    <div v-else>レビューがありません</div>
  </div>
</template>

<script>
import axios from "axios";
export default {
  name: "myreviews",
  data() {
    return {
      reviews: null
    };
  },
  mounted() {
    axios.get('/api/myreviews').then(res => {
      this.reviews = res.data;
    }); 
  },
  methods: {
    fav(reviewid) {
      axios.post("/api/givefav", {
        Id: reviewid
      });
    }
  }
};
</script>
