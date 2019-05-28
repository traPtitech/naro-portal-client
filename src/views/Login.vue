<template lang="pug">
  v-layout(justify-center align-center)
    v-flex(xs12 sm8 md4)
      v-card.elevation-12
        v-toolbar.dark(color="primary")
          v-toolbar-title ログイン
          v-spacer
          v-btn(color="info" @click="toRegister") 登録画面へ
        v-card-text
          v-form(ref="form")
            v-text-field(v-model="id" label="Id" required prepend-icon="person")
            v-text-field(type="password" v-model="pass" label="Password" required prepend-icon="lock")
          v-alert(:value="status === 'success'" type="success" transition="scale-transition")
            |ログインが完了しました
            |ページ遷移します
          v-alert(:value="status === 'error'" type="error" dismissible transition="scale-transition") {{ errorMessage }}
        v-card-actions
          v-btn(:loading="status === 'loading'" :disabled="submitDisabled" color="success" @click="submit") ログイン
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";
import { AuthsApi } from "../api";

@Component
export default class Login extends Vue {
  readonly ID_MAX_LENGTH = 30;
  readonly PASSWORD_MAX_LENGTH = 72;

  api: AuthsApi | null = null;
  id = "";
  pass = "";
  status: "none" | "loading" | "success" | "error" = "none";
  errorMessage = "";

  get submitDisabled(): boolean {
    return ["loading", "success"].includes(this.status);
  }

  async submit() {
    try {
      const promise = this.api!.login({
        id: this.id,
        password: this.pass
      });
      this.status = "loading";

      await promise;
      this.status = "success";

      await new Promise(resolve => setTimeout(resolve, 100));

      this.$router.push("/home");
    } catch (e) {
      if (e.message.includes("status code 403")) {
        this.errorMessage = "ユーザーIDまたはパスワードが間違っています";
      } else {
        this.errorMessage = "ログインに失敗しました";
      }
      this.status = "error";
    }
  }
  toRegister() {
    this.$router.push("/register");
  }

  async created() {
    this.api = new AuthsApi();
  }
}
</script>
