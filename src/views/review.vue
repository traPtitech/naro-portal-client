<template>
  <div>
    <h1>This is an review page</h1>
    <div>
      <label>
        作品
        <input type="text" v-model="title" />
      </label>
    </div>
    <div>
      <label>
        コメント
        <input type="text" v-model="comment" />
      </label>
      <button @click="review">送る</button>
    </div>
  </div>
</template>

<script>
import axios from "axios";
export default {
  name: "review",
  data() {
    return {
      title: "",
      comment: "",
    };
  },
  methods: {
    review() {
      axios.post("/api/review", {
        Title: this.title,
        Contents: this.comment
      });
    }
  }
};
</script>
