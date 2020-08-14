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
        ログインできませんでした。ユーザーIDとパスワードが正しいことを確認してください。
      </div>
      <el-form :model="loginForm" :rules="rules" ref="loginfForm">
        <el-form-item prop="userid">
          <el-input
            type="text"
            minlength="1"
            maxlength="30"
            placeholder="ユーザーID"
            v-model="loginForm.userid"
          />
        </el-form-item>
        <el-form-item prop="password">
          <el-input
            type="text"
            minlength="1"
            maxlength="30"
            placeholder="パスワード"
            v-model="loginForm.password"
          />
        </el-form-item>
        <el-form-item>
          <el-button round type="primary" @click="onLogin()"
            >ログインする</el-button
          >
        </el-form-item>
      </el-form>
    </div>
    <div>
      <h4>アカウントを持っていませんか？今すぐ作りましょう！</h4>
      <div class="error" v-if="registerError">
        このユーザーIDは既に使用されているか無効なIDです。別のIDを入力してください。
      </div>
      <el-form :model="registerForm" :rules="rules" ref="registerfForm">
        <el-form-item>
          <el-input
            type="text"
            minlength="1"
            maxlength="30"
            placeholder="ユーザーID"
            v-model="registerForm.newUserid"
          />
        </el-form-item>
        <el-form-item>
          <el-input
            type="text"
            minlength="1"
            maxlength="30"
            placeholder="アカウント名"
            v-model="registerForm.newUsername"
          />
        </el-form-item>
        <el-form-item>
          <el-input
            type="text"
            minlength="1"
            maxlength="30"
            placeholder="パスワード"
            v-model="registerForm.newPassword"
          />
        </el-form-item>
        <el-form-item>
          <el-button round type="primary" @click="onRegister()"
            >アカウントを作成する</el-button
          >
        </el-form-item>
      </el-form>
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
      loginError: false,
      registerError: false,
      loginForm: {
        userid: "",
        password: ""
      },
      registerForm: {
        newUserid: "",
        newUsername: "",
        newPassword: ""
      },
      rules: {
        userid: [
          {
            required: true,
            message: "ユーザーIDを入力してください",
            trigger: "change"
          }
        ],
        password: [
          {
            required: true,
            message: "パスワードを入力してください",
            trigger: "change"
          }
        ],
        newUserid: [
          {
            required: true,
            message: "ユーザーIDを入力してください",
            trigger: "change"
          }
        ],
        newUsername: [
          {
            required: true,
            message: "アカウント名を入力してください",
            trigger: "change"
          }
        ],
        newPassword: [
          {
            required: true,
            message: "パスワードを入力してください",
            trigger: "change"
          }
        ]
      }
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
      this.loginError = false;
      try {
        await axios.post("/api/login", {
          userid: this.loginForm.userid,
          password: this.loginForm.password
        });
      } catch (_) {
        this.$nextTick(function() {
          this.loginError = true;
        });
        return;
      }
      this.loginError = false;
      this.$notify({
        title: "ログイン成功",
        message: "ようこそ、@" + this.loginForm.userid + "さん！",
        duration: 2000
      });
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
      this.registerError = false;
      try {
        await axios.post("/api/signup", {
          userid: this.registerForm.newUserid,
          username: this.registerForm.newUsername,
          password: this.registerForm.newPassword
        });
      } catch (_) {
        this.$nextTick(function() {
          this.registerError = true;
        });
        return;
      }
      this.registerError = false;
      this.$router.go({ path: this.$router.currentRoute.path, force: true });
      this.$notify({
        title: "アカウント作成完了",
        message: "次は作成したアカウントでログインしましょう",
        duration: 2000
      });
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
