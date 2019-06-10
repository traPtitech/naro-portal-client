<template>
  <v-layout justify-center>
    <v-flex sm8 xs12>
      <v-layout wrap column justify-center>
        <v-layout
          justify-center
          class="light-blue lighten-1 white--text headline"
          >ログイン</v-layout
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
              @click="postLogin"
              class="light-blue lighten-1 white--text"
              >ログイン</v-btn
            >
            <v-btn
              round
              v-bind:disabled="isPush"
              @click="changeToSignup"
              class="light-blue lighten-1 white--text"
            >
              アカウントを新しく作る
            </v-btn>
          </v-layout>
        </v-form>
      </v-layout>
    </v-flex>
  </v-layout>
</template>
<script>
import axios from 'axios'
export default {
  name: 'Login',
  data() {
    return {
      name: null,
      password: null,
      message: '',
      isPush: false,
      valid: true,
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
    postLogin() {
      this.isPush = true
      axios
        .post('/api/login', {
          userName: this.name,
          userPassword: this.password,
        })
        .then(res => {
          if (res.data === 'OK') {
            this.$router.push('/')
          } else {
            this.message = '名前またはパスワードが間違っています'
          }
          this.isPush = false
        })
    },
    changeToSignup() {
      this.$router.push('/signup')
    },
  },
  mounted() {
    this.valid = false
  },
}
</script>
