<template>
  <div class="about" v-loading="loading">
    <div v-if="!profileFollowList.length">
      <h3>フォローしているユーザーはいません</h3>
    </div>
    <div v-else>
      <ul v-for="f in profileFollowList" v-bind:key="f.userid">
        <p>
          <i class="el-icon-user-solid" /><b>{{ f.username }} </b>
          <router-link :to="{ name: 'Profile', params: { userId: f.userid } }"
            >@{{ f.userid }}</router-link
          ><br />{{ f.biography }}<br />
          <el-button
            v-if="
              followList.findIndex(user => user.userid === f.userid) === -1 &&
                f.userid !== userData.userid
            "
            round
            type="primary"
            @click="onFollow(f.userid)"
            >フォロー</el-button
          ><el-button
            v-else-if="f.userid !== userData.userid"
            round
            type="danger"
            @click="onUnfollow(f.userid)"
            >フォロー解除</el-button
          >
        </p>
      </ul>
    </div>
  </div>
</template>
<script>
import axios from "axios";
export default {
  name: "Following",
  props: {
    profile: String
  },
  data() {
    return {
      profileData: {},
      followList: [],
      followerList: [],
      profileFollowList: [],
      profileFollowerList: [],
      loading: true
    };
  },
  computed: {
    userData() {
      return this.$store.getters.userData;
    }
  },
  mounted() {
    axios.get("/api/userInfo/" + this.$route.params["userId"]).then(res => {
      this.profileData = res.data;
      axios.get("/api/followList/" + this.profileData.userid).then(res => {
        if (res.data !== null) this.profileFollowList = res.data;
      });
      axios.get("/api/followerList/" + this.profileData.userid).then(res => {
        if (res.data !== null) this.profileFollowerList = res.data;
      });
    });
    axios.get("/api/whoami").then(res => {
      this.userData = res.data;
      axios.get("/api/followList/" + this.userData.userid).then(res => {
        this.loading = false;
        if (res.data !== null) this.followList = res.data;
      });
      axios.get("/api/followerList/" + this.userData.userid).then(res => {
        if (res.data !== null) this.followerList = res.data;
      });
    });
  },
  beforeRouteUpdate(to, from, next) {
    this.loading = true;
    this.tabName = "tweets";
    this.followList = [];
    this.followerList = [];
    this.profileFollowList = [];
    this.profileFollowerList = [];
    next(true);
    axios.get("/api/userInfo/" + this.$route.params["userId"]).then(res => {
      this.profileData = res.data;
      axios.get("/api/followList/" + this.profileData.userid).then(res => {
        if (res.data !== null) this.profileFollowList = res.data;
      });
      axios.get("/api/followerList/" + this.profileData.userid).then(res => {
        if (res.data !== null) this.profileFollowerList = res.data;
      });
    });
    axios.get("/api/list").then(res => {
      this.TweetList = res.data;
    });
    axios.get("/api/whoami").then(res => {
      this.userData = res.data;
      axios.get("/api/followList/" + this.userData.userid).then(res => {
        this.loading = false;
        if (res.data !== null) this.followList = res.data;
      });
      axios.get("/api/followerList/" + this.userData.userid).then(res => {
        if (res.data !== null) this.followerList = res.data;
      });
    });
  },
  methods: {
    async onFollow(followId) {
      try {
        await axios.post("/api/follow", {
          userid: this.userData.userid,
          followid: followId
        });
      } catch (_) {
        return;
      }
      this.followList = [];
      this.followerList = [];
      this.profileFollowList = [];
      this.profileFollowerList = [];
      axios.get("/api/followList/" + this.userData.userid).then(res => {
        if (res.data !== null) this.followList = res.data;
      });
      axios.get("/api/followerList/" + this.userData.userid).then(res => {
        if (res.data !== null) this.followerList = res.data;
      });
      axios.get("/api/followList/" + this.profileData.userid).then(res => {
        if (res.data !== null) this.profileFollowList = res.data;
      });
      axios.get("/api/followerList/" + this.profileData.userid).then(res => {
        if (res.data !== null) this.profileFollowerList = res.data;
      });
      return;
    },
    async onUnfollow(followId) {
      try {
        await axios.post("/api/unfollow", {
          userid: this.userData.userid,
          followid: followId
        });
      } catch (_) {
        return;
      }
      this.followList = [];
      this.followerList = [];
      this.profileFollowList = [];
      this.profileFollowerList = [];
      axios.get("/api/followList/" + this.userData.userid).then(res => {
        if (res.data !== null) this.followList = res.data;
      });
      axios.get("/api/followerList/" + this.userData.userid).then(res => {
        if (res.data !== null) this.followerList = res.data;
      });
      axios.get("/api/followList/" + this.profileData.userid).then(res => {
        if (res.data !== null) this.profileFollowList = res.data;
      });
      axios.get("/api/followerList/" + this.profileData.userid).then(res => {
        if (res.data !== null) this.profileFollowerList = res.data;
      });
      return;
    }
  }
};
</script>
