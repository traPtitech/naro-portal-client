<template lang="pug">
  .user
    h1 This is User Page
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";
import { UsersApi } from "../api";

@Component
export default class User extends Vue {
  api: UsersApi | null = null;
  created() {
    this.api = new UsersApi();
    this.api.getUser(this.$route.params.id);
  }
}
</script>
