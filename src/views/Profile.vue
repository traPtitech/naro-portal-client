<template>
  <div class="about" v-loading="loading">
    <div v-if="userData.userid === profileData.userid">
      <el-button round type="default" @click="onEditProfile()"
        >プロフィールを編集</el-button
      >
    </div>
    <div v-else>
      <el-button
        v-if="
          followList.findIndex(user => user.userid === profileData.userid) ===
            -1
        "
        round
        type="primary"
        @click="onFollow(profileData.userid)"
        >フォロー</el-button
      ><el-button
        v-else
        round
        type="danger"
        @click="onUnfollow(profileData.userid)"
        >フォロー解除</el-button
      >
    </div>
    <h1>{{ profileData.username }}</h1>
    <p>@{{ profileData.userid }}</p>
    <div>{{ profileData.biography }}<br /></div>
    <div v-if="profileData.website != ''">
      <i class="el-icon-paperclip" />
      <a id="website" :href="profileData.website" target="_blank">{{
        profileData.website
      }}</a
      ><br /><br />
      <router-link
        :to="{ name: 'Following', params: { userId: profileData.userid } }"
        ><b>{{ profileFollowList.length }} </b>フォロー
      </router-link>
      <router-link
        :to="{ name: 'Followers', params: { userId: profileData.userid } }"
        ><b>{{ profileFollowerList.length }} </b>フォロワ―</router-link
      >
    </div>
    <el-tabs v-model="tabName">
      <el-tab-pane label="ツイート" name="tweets"></el-tab-pane>
      <el-tab-pane label="いいね" name="favorites"></el-tab-pane>
    </el-tabs>
    <ul v-for="tl in TweetList" v-bind:key="tl.id">
      <p
        v-if="
          (tabName === 'tweets' && tl.userid === profileData.userid) ||
            (tabName === 'favorites' &&
              profileFavoriteList.findIndex(tweet => tweet.id === tl.id) != -1)
        "
      >
        <i class="el-icon-user-solid" /><b>{{ tl.username }} </b>
        <router-link :to="{ name: 'Profile', params: { userId: tl.userid } }"
          >@{{ tl.userid }}</router-link
        >・{{ tl.time }}
        <el-button
          v-if="tl.userid === userData.userid"
          circle
          type="danger"
          icon="el-icon-delete"
          @click="onDeleteTweet(tl.id)"
        ></el-button
        ><br /><br />{{ tl.text }}<br /><el-button
          v-if="favoriteList.findIndex(tweet => tweet.id === tl.id) === -1"
          circle
          type="default"
          icon="el-icon-star-off"
          @click="onFavorite(tl.id)"
        ></el-button
        ><el-button
          v-else
          circle
          type="warning"
          icon="el-icon-star-on"
          @click="onUnfavorite(tl.id)"
        ></el-button>
      </p>
    </ul>
  </div>
</template>
<script>
import axios from "axios";
export default {
  name: "Profile",
  props: {
    profile: String
  },
  data() {
    return {
      profileData: {},
      newText: "",
      TweetList: [],
      favoriteList: [],
      profileFavoriteList: [],
      followList: [],
      followerList: [],
      profileFollowList: [],
      profileFollowerList: [],
      tweetError: false,
      loading: true,
      tabName: "tweets"
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
      axios.get("/api/favoriteList/" + this.profileData.userid).then(res => {
        if (res.data !== null) this.profileFavoriteList = res.data;
      });
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
      axios.get("/api/favoriteList/" + this.userData.userid).then(res => {
        if (res.data !== null) this.favoriteList = res.data;
        this.loading = false;
      });
      axios.get("/api/followList/" + this.userData.userid).then(res => {
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
    this.favoriteList = [];
    this.followList = [];
    this.followerList = [];
    this.profileFavoriteList = [];
    this.profileFollowList = [];
    this.profileFollowerList = [];
    next(true);
    axios.get("/api/userInfo/" + this.$route.params["userId"]).then(res => {
      this.profileData = res.data;
      axios.get("/api/favoriteList/" + this.profileData.userid).then(res => {
        if (res.data !== null) this.profileFavoriteList = res.data;
      });
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
      axios.get("/api/favoriteList/" + this.userData.userid).then(res => {
        if (res.data !== null) this.favoriteList = res.data;
        this.loading = false;
      });
      axios.get("/api/followList/" + this.userData.userid).then(res => {
        if (res.data !== null) this.followList = res.data;
      });
      axios.get("/api/followerList/" + this.userData.userid).then(res => {
        if (res.data !== null) this.followerList = res.data;
      });
    });
  },
  methods: {
    async onTweet() {
      const date = new Date();
      try {
        await axios.post("/api/tweet", {
          id: String(Date.parse(date)),
          userid: this.userData.userid,
          time: date.toLocaleString(),
          text: this.newText
        });
      } catch (_) {
        this.tweetError = true;
        return;
      }
      this.tweetError = false;
      this.$router.go({ path: this.$router.currentRoute.path, force: true });
      return;
    },
    async onDeleteTweet(deleteId) {
      const target = this.tweetList.find(tweet => {
        return tweet.id === deleteId;
      });
      try {
        await axios.post("/api/deleteTweet", {
          id: target.id,
          userid: target.userid,
          time: target.time,
          text: target.text
        });
      } catch (_) {
        return;
      }
      this.tweetError = false;
      axios.get("/api/list").then(res => {
        this.tweetList = res.data;
      });
      this.$notify({
        title: "ツイートを削除しました",
        duration: 2000
      });
      return;
    },
    async onFavorite(favoriteId) {
      try {
        await axios.post("/api/favorite", {
          userid: this.userData.userid,
          tweetid: favoriteId
        });
      } catch (_) {
        return;
      }
      axios
        .get("/api/favoriteList/" + this.$store.state.userData.userid)
        .then(res => {
          this.favoriteList = res.data;
        });
      axios.get("/api/favoriteList/" + this.profileData.userid).then(res => {
        this.profileFavoriteList = res.data;
      });
      return;
    },
    async onUnfavorite(unfavoriteId) {
      try {
        await axios.post("/api/unfavorite", {
          userid: this.userData.userid,
          tweetid: unfavoriteId
        });
      } catch (_) {
        return;
      }
      axios
        .get("/api/favoriteList/" + this.$store.state.userData.userid)
        .then(res => {
          this.favoriteList = res.data;
        });
      axios.get("/api/favoriteList/" + this.profileData.userid).then(res => {
        this.profileFavoriteList = res.data;
      });
      return;
    },
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
    async onUnfollow(unfollowId) {
      try {
        await axios.post("/api/unfollow", {
          userid: this.userData.userid,
          followid: unfollowId
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
    onEditProfile() {
      this.$router.push("/EditProfile");
      return;
    }
  }
};
</script>
