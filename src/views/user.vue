<template>
  <div>
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
  name: "User",
  data() {
    return {
      reviews: null
    };
  },
  mounted() {
    const userName = this.$route.params.userName;
    axios.get("/api/users/" + userName).then(res => {
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
