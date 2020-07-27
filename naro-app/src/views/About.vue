<template>
  <div class="about">
    <h2>Webエンジニアになろう講習会</h2>
    <h1>Twitterクローン</h1>
    <el-input
      type="text"
      minlength="1"
      maxlength="140"
      placeholder="いまどうしてる？"
      v-model="newText"
    />
    <el-button round type="primary" @click="onclick()">ツイートする</el-button>
    <ul v-for="p in posts" v-bind:key="p.id">
      <p>{{ p.id }} {{ p.text }}</p>
    </ul>
  </div>
</template>
<script>
export default {
  name: "Home",
  data() {
    return {
      newText: "",
      newId: 0,
      posts: []
    };
  },
  methods: {
    onclick() {
      this.posts.push({ id: this.newId, text: this.newText });
      this.newText = "";
      this.newId++;
      return;
    }
  }
};
</script>
