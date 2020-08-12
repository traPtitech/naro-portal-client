<template>
  <div class="about" v-loading="loading">
    <h2>Webエンジニアになろう講習会</h2>
    <h1>Twitterクローン</h1>
    <h3>ようこそ！{{ userData.username }}さん！</h3>
    <p>あなたのユーザーID：@{{ userData.userid }}</p>
    <div class="error" v-if="tweetError">
      1文字以上の入力が必要です！
    </div>
    <el-input
      type="text"
      minlength="1"
      maxlength="140"
      placeholder="いまどうしてる？"
      v-model="newText"
    />
    <el-button round type="primary" @click="onTweet()">ツイートする</el-button>
    <ul v-for="tl in tweetList" v-bind:key="tl.id">
      <p>
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
  name: "Home",
  props: {
    home: String
  },
  data() {
    return {
      newText: "",
      tweetList: [],
      favoriteList: [],
      tweetError: false,
      loading: true
    };
  },
  computed: {
    userData() {
      return this.$store.getters.userData;
    }
  },
  mounted() {
    axios.get("/api/list").then(res => {
      this.tweetList = res.data;
    });
    axios.get("/api/whoami").then(res => {
      this.$store.commit("updateUserData", res.data);
      axios
        .get("/api/favoriteList/" + this.$store.state.userData.userid)
        .then(res => {
          if (res.data !== null) this.favoriteList = res.data;
          this.loading = false;
        });
    });
  },
  methods: {
    async onTweet() {
      const date = new Date();
      if (!this.newText.length) {
        this.tweetError = true;
      } else {
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
        axios.get("/api/list").then(res => {
          this.tweetList = res.data;
        });
        return;
      }
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
      this.favoriteList = [];
      axios
        .get("/api/favoriteList/" + this.$store.state.userData.userid)
        .then(res => {
          if (res.data !== null) this.favoriteList = res.data;
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
