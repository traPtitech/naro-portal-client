<template>
  <v-layout justify-center>
    <v-flex sm6 xs12>
      <v-layout wrap column justify-center>
        <v-flex sm4 xs5>
          <v-layout wrap row justify-center class="light-blue lighten-1">
            <v-flex sm4 xs5>
              <v-select
                v-model="userName"
                item-text="userName"
                :items="users"
                menu-props="auto"
                hide-details
                m-0
                p-0
                class="white--text headline"
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

            <v-layout justify-end>
              <v-btn
                outline
                v-bind:disabled="isPush"
                round
                @click="changeToFavoList"
                class="white white--text"
                >MyFavoList</v-btn
              >
              <v-btn
                outline
                v-bind:disabled="isPush"
                round
                @click="logout"
                class="white white--text"
                >ログアウト</v-btn
              >
            </v-layout>
          </v-layout>
        </v-flex>
        <v-form v-model="valid" lazy-validation>
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
              axios.get('/api/timelinePin/' + this.userName).then(res => {
                this.pins = res.data
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
              axios.get('/api/timelinePin/' + this.userName).then(res => {
                this.pins = res.data
              })
            })
        }
      })
    },
    postPin(tweetID) {
      this.isPush = true
      axios.get('/api/isPin/' + tweetID).then(res => {
        if (res.data !== 'none') {
          axios
            .delete('/api/pin', {
              data: {
                tweetID: tweetID,
              },
            })
            .then(() => {
              axios.get('/api/timeline/' + this.userName).then(res => {
                this.tweets = res.data
                this.isPush = false
              })
              axios.get('/api/timelinePin/' + this.userName).then(res => {
                this.pins = res.data
              })
            })
        } else {
          axios
            .post('/api/pin', {
              tweetID: tweetID,
            })
            .then(() => {
              axios.get('/api/timeline/' + this.userName).then(res => {
                this.tweets = res.data
                this.isPush = false
              })
              axios.get('/api/timelinePin/' + this.userName).then(res => {
                this.pins = res.data
              })
            })
        }
      })
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
