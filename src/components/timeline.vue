<template>
  <div id="timeline">
    <h1>{{ userName }}</h1>
    <div v-for="(tweet, index) in tweets" :key="index" class="tweet">
      <div class="time">{{ tweet.createdAt }}</div>
      <button v-bind:disabled="isPush" @click="postFavo(tweet.tweetID)">
        favo
      </button>
      <div class="favoNum">{{ tweet.favoNum - 1 }}</div>
      <div class="tweet">{{ tweet.tweet }}</div>
    </div>
    <div>
      <input type="text" v-model="text" />
      <button v-bind:disabled="isPush" @click="postTweet">送信</button>
      <div id="message">{{ message }}</div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  name: 'Timeline',
  data() {
    return {
      userName: null,
      tweets: null,
      text: '',
      message: '',
      isPush: false,
    }
  },
  methods: {
    postTweet() {
      this.isPush = true
      if (this.text === '') {
        this.message = '空のTweetはできません'
      } else {
        axios.post('/api/tweet', {
          tweet: this.text,
        })
        axios.get('/api/timeline/' + this.userName).then(res => {
          this.tweets = res.data
        })
      }
      this.isPush = false
    },
    postFavo(tweetID) {
      this.isPush = true
      axios
        .post('/api/isFavo', {
          tweetID: tweetID,
        })
        .then(res => {
          if (res.data !== 'none') {
            axios
              .post('/api/favoDelete', {
                tweetID: tweetID,
              })
              .then(
                axios.get('/api/timeline/' + this.userName).then(res => {
                  this.tweets = res.data
                  this.isPush = false
                })
              )
          } else {
            axios
              .post('/api/favoAdd', {
                tweetID: tweetID,
              })
              .then(
                axios.get('/api/timeline/' + this.userName).then(res => {
                  this.tweets = res.data
                  this.isPush = false
                })
              )
          }
        })
    },
  },
  beforeCreate() {
    axios.get('/api/whoAmI').then(res => {
      this.userName = res.data.userName
      axios.get('/api/timeline/' + this.userName).then(res => {
        this.tweets = res.data
      })
    })
  },
}
</script>

<style></style>
