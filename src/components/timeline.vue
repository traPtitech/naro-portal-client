<template>
  <div id="timeline">
    <h1>{{ this.userName }}</h1>
    <div v-for="tweet in tweets" :key="tweet.tweetID" class="tweet">
      <div class="time">{{ tweet.createdAt }}</div>
      <button v-bind:disabled="isPush" @click="postFavo(tweet.tweetID)">
        favo
      </button>
      <div class="favoNum">{{ tweet.favoNum || 0 }}</div>
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
import { setInterval, clearInterval } from 'timers'
export default {
  name: 'Timeline',
  data() {
    return {
      userName: null,
      tweets: null,
      text: '',
      message: '',
      isPush: false,
      upDateTweetTimer: null,
    }
  },
  methods: {
    postTweet() {
      this.isPush = true
      if (this.text === '') {
        this.message = '空のTweetはできません'
      } else {
        axios.post('/api/tweet', { tweet: this.text }).then(() => {
          axios.get('/api/timeline/' + this.userName).then(res => {
            this.tweets = res.data
          })
        })
      }
      this.text = ''
      this.isPush = false
    },
    postFavo(tweetID) {
      this.isPush = true
      axios.get('/api/isFavo/' + tweetID).then(res => {
        if (res.data !== 'none') {
          axios
            .delete('/api/favo', {
              data: {
                tweetID: tweetID,
              },
            })
            .then(() => {
              axios.get('/api/timeline/' + this.userName).then(res => {
                this.tweets = res.data
                this.isPush = false
              })
            })
        } else {
          axios
            .post('/api/favo', {
              tweetID: tweetID,
            })
            .then(() => {
              axios.get('/api/timeline/' + this.userName).then(res => {
                this.tweets = res.data
                this.isPush = false
              })
            })
        }
      })
    },
    reloadTweet() {
      axios.get('/api/reloadTimeline/' + this.userName).then(res => {
        if (res === 'new message exist') {
          axios.get('/api/timeline/' + this.userName).then(res => {
            this.tweets = res.data
          })
        }
      })
    },
  },
  mounted() {
    this.upDateTweetTimer = setInterval(this.reloadTweet, 5000)
  },
  destroyed() {
    clearInterval(this.upDateTweetTimer)
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
