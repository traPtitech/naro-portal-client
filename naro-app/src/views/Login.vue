<template>
  <div class="login">
    <h1 v-if="!userData.userid.length">
      まずはログインしましょう
    </h1>
    <div v-else>
      <h3>現在あなたは@{{ userData.userid }}としてログインしています。</h3>
      <el-button round type="danger" @click="onLogout()"
        >ログアウトする</el-button
      >
      <h3>別のアカウントでログインしますか？</h3>
    </div>
    <div>
      <div class="error" v-if="loginError">
        有効なIDとパスワードを入力してください！
      </div>
      <el-input
        type="text"
        minlength="1"
        maxlength="140"
        placeholder="ユーザーID"
        v-model="userid"
      />
      <el-input
        type="text"
        minlength="1"
        maxlength="140"
        placeholder="パスワード"
        v-model="password"
      />
    </div>
    <div>
      <el-button round type="primary" @click="onLogin()"
        >ログインする</el-button
      >
    </div>
    <div>
      <h4>アカウントを持っていませんか？今すぐ作りましょう！</h4>
      <div class="error" v-if="registerError">
        有効なIDとパスワードを入力してください！
      </div>
      <el-input
        type="text"
        minlength="1"
        maxlength="140"
        placeholder="ユーザーID"
        v-model="newUserid"
      />
      <el-input
        type="text"
        minlength="1"
        maxlength="140"
        placeholder="アカウント名"
        v-model="newUsername"
      />
      <el-input
        type="text"
        minlength="1"
        maxlength="140"
        placeholder="パスワード"
        v-model="newPassword"
      />
      <el-button round type="primary" @click="onRegister()"
        >アカウントを作成する</el-button
      >
    </div>
  </div>
</template>

<script>
import axios from "axios";
export default {
  name: "Login",
  props: {
    login: String
  },
  data() {
    return {
      userid: "",
      password: "",
      newUserid: "",
      newUsername: "",
      newPassword: "",
      loginError: false,
      registerError: false
    };
  },
  computed: {
    userData() {
      return this.$store.getters.userData;
    }
  },
  mounted() {
    axios.get("/api/whoami").then(res => {
      this.$store.commit("updateUserData", res.data);
    });
  },
  methods: {
    async onLogin() {
      try {
        await axios.post("/api/login", {
          userid: this.userid,
          password: this.password
        });
      } catch (_) {
        this.$nextTick(function() {
          this.loginError = true;
        });
        return;
      }
      this.loginError = false;
      this.$router.push("/");
      return;
    },
    async onLogout() {
      try {
        await axios.post("/api/logout", {});
      } catch (_) {
        return;
      }
      this.$router.go({ path: this.$router.currentRoute.path, force: true });
      return;
    },
    async onRegister() {
      try {
        await axios.post("/api/signup", {
          userid: this.newUserid,
          username: this.newUsername,
          password: this.newPassword
        });
      } catch (_) {
        this.$nextTick(function() {
          this.registerError = true;
        });
        return;
      }
      this.registerError = false;
      this.$router.go({ path: this.$router.currentRoute.path, force: true });
      return;
    }
  }
};
</script>

<style>
.error {
  color: red;
}
</style>
