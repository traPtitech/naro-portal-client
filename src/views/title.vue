<template>
   <div>
    <!-- <div>{{ reviews.title }}</div> -->
    <div v-if="reviews">
      <div v-for="review in reviews" :key="review.name">
          <div>
              投稿者:
              <router-link :to="'/users/' + review.username">
                {{ review.username }}
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
  name: "Title",
  data() {
    return {
      reviews: null
    };
  },
  mounted() {
    const titleName = this.$route.params.titleName;
    axios.get("/api/titles/" + titleName).then(res => {
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
