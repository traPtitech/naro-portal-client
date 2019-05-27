<template lang="pug">
  .register
    h1 This is Register Page
    v-form(ref="form" v-model="valid" lazy-validation)
      v-text-field(v-model="id" :counter="30" :rules="idRules" label="Id" required)
      v-text-field(v-model="pass" :counter="72" :rules="passRules" label="Password" required)
      v-btn(:disabled="!valid" color="success" @click="submit") 登録
      v-btn(color="error" @click="reset")
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";
import { AuthsApi } from "../api";

const ID_MAX_LENGTH = 30;
const PASSWORD_MAX_LENGTH = 72;

@Component({})
export default class Register extends Vue {
  $refs!: {
    form: Vue & {
      validate: () => boolean;
      reset: () => void;
    };
  };

  api: AuthsApi | null = null;
  valid = true;
  id = "";
  idRules = [
    (v: string) => !!v || "IDは必須です",
    (v: string) => (v && v.length <= ID_MAX_LENGTH) || "IDは10文字以内です"
  ];
  pass = "";
  passRules = [
    (v: string) => !!v || "IDは必須です",
    (v: string) =>
      (v && v.length <= PASSWORD_MAX_LENGTH) || "IDは10文字以内です"
  ];

  submit() {
    if (this.$refs.form.validate()) {
      this.valid = true;
      // send
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
