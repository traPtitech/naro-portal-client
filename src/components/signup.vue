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
      message: '',
      isPush: false,
      nameRules: [
        v => !!v || 'ユーザ名は必須です',
        v => v.length <= 16 || 'ユーザ名は16文字までです',
      ],
      passwordRules: [
        v => !!v || 'ユーザ名は必須です',
        v => v.length <= 16 || 'ユーザ名は16文字までです',
        v => v.length >= 8 || 'ユーザ名は8文字以上です',
      ],
    }
  },
  methods: {
    postSignup() {
      this.isPush = true
      axios
        .post('/api/signup', {
          userName: this.name,
          userPassword: this.password,
        })
        .then(res => {
          this.$router.push('/')
          this.isPush = false
        })
        .catch(err => {
          if (err.response.status === 400) {
            this.message = err.response.data.message
          } else {
            console.error({
              statusCode: err.response.status,
              message: err.response.data.message,
            })
          }
          this.isPush = false
        })
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
