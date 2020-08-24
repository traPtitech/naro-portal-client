<template>
  <div class="about">
    <p>あなたのユーザーID：@{{ userData.userid }}</p>
    <div class="error" v-if="updateError">
      1文字以上の入力が必要です！
    </div>
    <el-form ref="form" :model="form" :rule="rules" label-width="120px">
      <el-form-item label="名前" prop="username">
        <el-input
          type="text"
          minlength="1"
          maxlength="30"
          v-model="form.newUserName"
        />
      </el-form-item>
      <el-form-item label="自己紹介" prop="biography">
        <el-input
          type="textarea"
          minlength="1"
          maxlength="140"
          v-model="form.newBiography"
        />
      </el-form-item>
      <el-form-item label="ウェブサイト" prop="website">
        <el-input
          type="text"
          minlength="1"
          maxlength="500"
          v-model="form.newWebsite"
        />
      </el-form-item>
      <el-form-item>
        <el-button round type="primary" @click="onUpdateProfile()"
          >保存</el-button
        >
      </el-form-item>
    </el-form>
  </div>
</template>
<script>
import axios from "axios";
export default {
  name: "EditProfile",
  props: {
    editProfile: String
  },
  data() {
    return {
      updateError: false,
      form: {
        newUserName: "",
        newBiography: "",
        newWebsite: ""
      },
      rules: {
        username: [
          {
            required: true,
            message: "アカウント名は1文字以上にしてください！",
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
      this.form.userData = res.data;
      this.form.newUserName = this.userData.username;
      this.form.newBiography = this.userData.biography;
      this.form.newWebsite = this.userData.website;
    });
  },
  methods: {
    async onUpdateProfile() {
      this.updateError = false;
      if (!this.form.newUserName.length) {
        this.updateError = true;
        return;
      } else {
        try {
          await axios.post("/api/updateProfile", {
            userid: this.userData.userid,
            username: this.form.newUserName,
            biography: this.form.newBiography,
            website: this.form.newWebsite
          });
        } catch (_) {
          this.updateError = true;
          return;
        }
        this.updateError = false;
        this.$notify({
          title: "プロフィールを更新しました",
          duration: 2000
        });
        this.$router.push("/profile/" + this.userData.userid);
        return;
      }
    }
  }
};
</script>
