<template>
  <v-layout justify-center column>
    <v-layout justify-center>
      <v-flex sm6 xs12>
        <v-layout wrap column justify-center>
          <v-flex sm4 xs5>
            <v-layout
              wrap
              row
              justify-center
              class="light-blue lighten-1 pb-2 pt-2"
            >
              <v-flex sm4 xs5>
                <v-select
                  v-model="userName"
                  item-text="userName"
                  :items="users"
                  menu-props="auto"
                  hide-details
                  class="white--text headline mt-0 pt-0"
                />
              </v-flex>

              <v-btn
                outline
                v-bind:disabled="isPush"
                round
                @click="loadTweet"
                class="white white--text"
                >see this user`s timeline</v-btn
              >
            </v-layout>
          </v-flex>
          <v-flex xs12>
            <v-card
              v-for="tweet in pins"
              :key="tweet.pinID"
              class="amber lighten-4"
            >
              <v-card-title class="pt-0 pb-0">
                <v-layout wrap row justify-end align-center>
                  {{
                    tweet.createdAt
                      .replace('T', ' ')
                      .replace('Z', '')
                      .replace('-', '/')
                      .replace('-', '/')
                  }}
                  <v-btn
                    flat
                    icon
                    color="pink"
                    v-bind:disabled="isPush"
                    @click="postFavo(tweet.tweetID)"
                  >
                    <v-icon>favorite</v-icon>
                  </v-btn>

                  {{ tweet.favoNum || 0 }}
                  <v-btn
                    flat
                    icon
                    color="amber darken-4"
                    v-bind:disabled="isPush || isPin"
                    @click="postPin(tweet.tweetID)"
                  >
                    <v-icon>fa-thumbtack</v-icon>
                  </v-btn>
                </v-layout>
              </v-card-title>
              <v-card-text class="pt-0">{{ tweet.tweet }}</v-card-text>
            </v-card>
          </v-flex>

          <v-flex xs12>
            <v-card v-for="tweet in tweets" :key="tweet.tweetID">
              <v-card-title class="pt-0 pb-0">
                <v-layout wrap row justify-end align-center>
                  {{
                    tweet.createdAt
                      .replace('T', ' ')
                      .replace('Z', '')
                      .replace('-', '/')
                      .replace('-', '/')
                  }}
                  <v-btn
                    flat
                    icon
                    color="pink"
                    v-bind:disabled="isPush"
                    @click="postFavo(tweet.tweetID)"
                  >
                    <v-icon>favorite</v-icon>
                  </v-btn>

                  {{ tweet.favoNum || 0 }}
                  <v-btn
                    flat
                    icon
                    color="amber darken-4"
                    v-bind:disabled="isPush || isPin"
                    @click="postPin(tweet.tweetID)"
                  >
                    <v-icon>fa-thumbtack</v-icon>
                  </v-btn>
                </v-layout>
              </v-card-title>
              <v-card-text class="pt-0">{{ tweet.tweet }}</v-card-text>
            </v-card>
          </v-flex>
        </v-layout>
      </v-flex>
    </v-layout>

    <v-bottom-sheet persistent hide-overlay v-model="sheet2" v-if="!isPin">
      <v-layout justify-end>
        <v-btn
          flat
          icon
          color="grey darken-2"
          v-bind:disabled="isPush || isPin"
          @click="click"
        >
          <v-icon>fa-angle-double-up</v-icon>
        </v-btn>
      </v-layout>
    </v-bottom-sheet>

    <v-flex xs12>
      <v-bottom-sheet persistent hide-overlay v-model="sheet1" v-if="!isPin">
        <template v-slot:activator> </template>
        <v-form v-model="valid">
          <v-layout justify-center>
            <v-flex sm6 xs9>
              <v-layout column>
                <v-textarea
                  maxlength="200"
                  counter
                  :rules="tweetRule"
                  auto-grow
                  rows="1"
                  v-model="text"
                />
                <v-flex sm3 xs5>
                  <v-layout justify-center>
                    <v-btn
                      round
                      v-bind:disabled="isPush || !valid"
                      @click="postTweet"
                      class="light-blue lighten-1 white--text"
                    >
                      送信
                    </v-btn>
                  </v-layout>
                </v-flex>
              </v-layout>
            </v-flex>
          </v-layout>
        </v-form>
        <v-layout justify-end>
          <v-btn
            flat
            icon
            color="grey darken-2"
            v-bind:disabled="isPush || isPin"
            @click="click"
          >
            <v-icon>fa-angle-double-down</v-icon>
          </v-btn>
        </v-layout>
      </v-bottom-sheet>
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
      pins: null,
      text: '',
      message: '',
      isPush: false,
      isPin: false,
      valid: true,
      users: null,
      sheet1: true,
      sheet2: false,
      upDateTweetTimer: null,
      tweetRule: [
        v => !!v || '空のTweetはできません',
        v => v.length <= 200 || 'Tweetの字数はは200文字までです',
      ],
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
          axios.get('/api/timelinePin/' + this.userName).then(res => {
            this.pins = res.data
          })
        })
      }
      this.text = ''
      this.isPush = false
    },
    postFavo(tweetID) {
      this.isPush = true
      axios
        .post('/api/favo', {
          tweetID: tweetID,
        })
        .then(() => {
          axios.get('/api/timeline/' + this.userName).then(res => {
            this.tweets = res.data
          })
          axios.get('/api/timelinePin/' + this.userName).then(res => {
            this.pins = res.data
          })
        })
      this.text = ''
      this.isPush = false
    },
    postPin(tweetID) {
      this.isPush = true
      axios
        .post('/api/pin', {
          tweetID: tweetID,
        })
        .then(() => {
          axios.get('/api/timeline/' + this.userName).then(res => {
            this.tweets = res.data
          })
          axios.get('/api/timelinePin/' + this.userName).then(res => {
            this.pins = res.data
          })
        })
      this.text = ''
      this.isPush = false
    },
    changeToFavoList() {
      this.$router.push('/favoList')
    },
    loadTweet() {
      axios.get('/api/whoAmI').then(res => {
        if (this.userName !== res.data.userName) {
          this.isPin = true
        } else {
          this.isPin = false
        }
      })
      axios.get('/api/timeline/' + this.userName).then(res => {
        this.tweets = res.data
      })
      axios.get('/api/timelinePin/' + this.userName).then(res => {
        this.pins = res.data
      })
    },
    reloadTweet() {
      axios.get('/api/reloadTimeline/' + this.userName).then(res => {
        if (res === 'new message exist') {
          axios.get('/api/timeline/' + this.userName).then(res => {
            this.tweets = res.data
          })
          axios.get('/api/timelinePin/' + this.userName).then(res => {
            this.pins = res.data
          })
        }
      })
    },
    logout() {
      axios.post('/api/logout').then(() => {
        this.$router.push('/login')
      })
    },
    click() {
      this.sheet1 = !this.sheet1
      this.sheet2 = !this.sheet2
    },
  },
  mounted() {
    this.valid = false
    this.upDateTweetTimer = setInterval(this.reloadTweet, 5000)
  },
  destroyed() {
    clearInterval(this.upDateTweetTimer)
  },
  beforeCreate() {
    axios.get('/api/whoAmI').then(res => {
      this.userName = res.data.userName
      axios.get('/api/userName').then(res => {
        this.users = res.data
      })
      axios.get('/api/timeline/' + this.userName).then(res => {
        this.tweets = res.data
      })
      axios.get('/api/timelinePin/' + this.userName).then(res => {
        this.pins = res.data
      })
    })
  },
}
</script>
