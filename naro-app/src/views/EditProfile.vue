<template>
  <div class="about">
    <p>あなたのユーザーID：@{{ userData.userid }}</p>
    <div class="error" v-if="updateError">
      1文字以上の入力が必要です！
    </div>
    <p>名前</p>
    <el-input type="text" minlength="1" maxlength="20" v-model="newUserName" />
    <p>自己紹介</p>
    <el-input
      type="text"
      minlength="1"
      maxlength="140"
      v-model="newBiography"
    />
    <p>ウェブサイト</p>
    <el-input type="text" minlength="1" maxlength="500" v-model="newWebsite" />
    <el-button round type="primary" @click="onUpdateProfile()">保存</el-button>
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
      newUserName: "",
      newBiography: "",
      newWebsite: "",
      updateError: false
    };
  },
  computed: {
    userData() {
      return this.$store.getters.userData;
    }
  },
  mounted() {
    axios.get("/api/whoami").then(res => {
      this.userData = res.data;
      this.newUserName = this.userData.username;
      this.newBiography = this.userData.biography;
      this.newWebsite = this.userData.website;
    });
  },
  methods: {
    async onUpdateProfile() {
      if (!this.newUserName.length) {
        this.updateError = true;
        return;
      } else {
        try {
          await axios.post("/api/updateProfile", {
            userid: this.userData.userid,
            username: this.newUserName,
            biography: this.newBiography,
            website: this.newWebsite
          });
        } catch (_) {
          this.updateError = true;
          return;
        }
        this.updateError = false;
        this.$router.push("/profile/" + this.userData.userid);
        return;
      }
    }
  }
};
</script>
