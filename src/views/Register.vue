<template lang="pug">
  .register
    h1 This is Register Page
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";
import { AuthsApi } from "../api";

export default class Register extends Vue {
  api: AuthsApi | null = null;
  async created() {
    this.api = new AuthsApi();
  }
}
</script>
