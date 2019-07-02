<template>
  <v-layout justify-center>
    <v-flex sm8 xs12>
      <v-layout wrap column justify-center>
        <v-layout
          justify-center
          class="light-blue lighten-1 white--text headline"
          >サインアップ</v-layout
        >

        <v-form v-model="valid" lazy-validation>
          <v-text-field
            row="1"
            :rules="nameRules"
            label="UserID"
            v-model="name"
          />

          <v-text-field
            counter
            label="Password"
            type="password"
            row="1"
            :rules="passwordRules"
            v-model="password"
          />
          <v-card-text
            v-for="message in messages"
            :key="message"
            class="red--text title"
          >
            {{ message }}
          </v-card-text>
          <v-layout row wrap justify-center>
            <v-btn
              round
              v-bind:disabled="isPush || !valid"
              @click="postSignup"
              class="light-blue lighten-1 white--text"
              >サインアップ</v-btn
            >
            <v-btn
              round
              v-bind:disabled="isPush"
              @click="changeToLogin"
              class="light-blue lighten-1 white--text"
              >ログイン画面へ</v-btn
            >
          </v-layout>
        </v-form>
      </v-layout>
    </v-flex>
  </v-layout>
</template>
<script>
import axios from 'axios'
export default {
  name: 'Signup',
  data() {
    return {
      name: null,
      password: null,
      messages: [],
      isPush: false,
      valid: false,
      nameRules: [
        v => !!v || 'ユーザ名は必須です',
        v => v.length <= 16 || 'ユーザ名は16文字までです',
      ],
      passwordRules: [
        v => !!v || 'パスワードは必須です',
        v => v.length >= 8 || 'パスワードは8文字以上です',
      ],
    }
  },
  methods: {
    async postSignup() {
      this.isPush = true
      await axios
        .post('/api/signup', {
          userName: this.name,
          userPassword: this.password,
        })
        .catch(err => {
          if (err.response.status === 400) {
            this.messages.push(err.response.data)
          } else {
            this.messages = []
            this.messages.push('エラー')
          }
          this.isPush = false
        })
      if (this.isPush) {
        this.$router.push('/')
        this.isPush = false
      }
    },
    changeToLogin() {
      this.$router.push('/login')
    },
  },
  mounted() {
    this.valid = false
  },
}
</script>
