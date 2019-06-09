<template>
  <v-layout justify-center>
    <v-flex sm8 xs12>
      <v-layout wrap column justify-center>
        <v-layout row wrap class="light-blue lighten-1" justify-center
          ><h1>{{ this.userName }}</h1>
          <v-btn v-bind:disabled="isPush" round @click="logout" class="white"
            ><span id="bottun">ログアウト</span></v-btn
          ></v-layout
        >

        <v-card v-for="tweet in tweets" :key="tweet.tweetID" class="tweet">
          <v-card-text
            ><v-layout wrap row justify-center aline-center
              >{{ tweet.createdAt }}
              <v-btn
                flat
                icon
                color="pink"
                v-bind:disabled="isPush"
                @click="postFavo(tweet.tweetID)"
              >
                <v-icon>favorite</v-icon>
              </v-btn>
              {{ tweet.favoNum || 0 }}</v-layout
            ></v-card-text
          >
          <v-card-text>{{ tweet.tweet }}</v-card-text>
        </v-card>

        <v-textarea v-model="text" />
        <button v-bind:disabled="isPush" @click="postTweet">送信</button>
      </v-layout>
    </v-flex>
  </v-layout>
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
    logout() {
      axios.post('/api/logout').then(() => {
        this.$router.push('/login')
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
