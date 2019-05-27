<template lang="pug">
  .home
    h1 This is Home Page
    p {{ posts }}
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";
import { PostsApi, Post } from "../api";

export default class Home extends Vue {
  api: PostsApi | null = null;
  posts: Post[] = [];
  async created() {
    this.api = new PostsApi();
    console.log(await this.api.getPosts());
  }
}
</script>
