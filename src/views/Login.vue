<template lang="pug">
  .login
    h1 This is Login Page
    router-link(to="/register") register
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";
import { AuthsApi } from "../api";

@Component
export default class Login extends Vue {
  api: AuthsApi | null = null;
  async created() {
    this.api = new AuthsApi();
  }
}
</script>
