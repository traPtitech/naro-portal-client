<template lang="pug">
  v-layout(justify-center align-center)
    v-flex(xs12 sm8 md4)
      v-card.elevation-12
        v-toolbar.dark(color="primary")
          v-toolbar-title 登録フォーム
        v-card-text
          v-form(ref="form" v-model="valid" lazy-validation)
            v-text-field(v-model="id" :counter="ID_MAX_LENGTH" :rules="idRules" label="Id" required prepend-icon="person")
            v-text-field(type="password" v-model="pass" :counter="PASSWORD_MAX_LENGTH" :rules="passRules" label="Password" required prepend-icon="lock")
          v-alert(:value="status === 'success'" type="success" transition="scale-transition")
            |登録が完了しました
            |ページ遷移します
          v-alert(:value="status === 'error'" type="error" dismissible transition="scale-transition") 登録に失敗しました
        v-card-actions
          v-btn(:loading="status === 'loading'" :disabled="submitDisabled" color="success" @click="submit") 登録
          v-btn(color="error" @click="reset") リセット
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";
import { AuthsApi } from "../api";

@Component
export default class Register extends Vue {
  $refs!: {
    form: Vue & {
      validate: () => boolean;
      reset: () => void;
    };
  };

  readonly ID_MAX_LENGTH = 30;
  readonly PASSWORD_MAX_LENGTH = 72;

  api: AuthsApi | null = null;
  valid = true;
  id = "";
  idRules = [
    (v: string) => !!v || "IDは必須です",
    (v: string) =>
      (v && v.length <= this.ID_MAX_LENGTH) ||
      `IDは${this.ID_MAX_LENGTH}文字以内です`
  ];
  pass = "";
  passRules = [
    (v: string) => !!v || "パスワードは必須です",
    (v: string) =>
      (v && v.length <= this.PASSWORD_MAX_LENGTH) ||
      `パスワードは${this.PASSWORD_MAX_LENGTH}文字以内です`
  ];
  status: "none" | "loading" | "success" | "error" = "none";

  get submitDisabled(): boolean {
    return !this.valid || ["loading", "success"].includes(this.status);
  }

  async submit() {
    if (this.$refs.form.validate()) {
      this.valid = true;
      try {
        const promise = this.api!.signup({
          id: this.id,
          password: this.pass
        });
        this.status = "loading";

        await promise;
        this.status = "success";

        await new Promise(resolve => setTimeout(resolve, 100));

        this.$router.push("/home");
      } catch {
        this.status = "error";
      }
    } else {
      this.valid = false;
    }
  }
  reset() {
    this.$refs.form.reset();
  }

  async created() {
    this.api = new AuthsApi();
  }
}
</script>
