<template>
  <v-app>
    <v-toolbar class="light-blue lighten-1">
      <v-layout justify-center>
        <v-toolbar-title class="headline white--text">
          TwitterClone
        </v-toolbar-title>
      </v-layout>
      <v-menu
        bottom
        origin="center center"
        transition="scale-transition"
        v-if="isVisible"
      >
        <template v-slot:activator="{ on }">
          <v-btn depressed color="light-blue lighten-1" v-on="on">
            <v-icon color="white">menu</v-icon>
          </v-btn>
        </template>

        <v-list>
          <v-list-tile
            v-for="item in items"
            :key="item.title"
            @click="item.change"
          >
            <v-list-tile-title>{{ item.title }}</v-list-tile-title>
          </v-list-tile>
        </v-list>
      </v-menu>
    </v-toolbar>

    <v-container>
      <router-view />
    </v-container>

    <v-dialog v-model="dialog1" width="500">
      <v-card>
        <v-card-text>
          本当にアカウントを削除しますか？アカウントを削除すると復元はできません。
        </v-card-text>

        <v-divider></v-divider>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="primary" flat @click="delAccount">
            Delete Account
          </v-btn>
          <v-btn color="primary" flat @click="dialog1 = false">
            Cancel
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-dialog v-model="dialog2" width="500">
      <v-card>
        <v-card-text>
          アカウントを削除しました。1秒後に自動でログイン画面に移動します。
        </v-card-text>
      </v-card>
    </v-dialog>
  </v-app>
</template>

<script>
import axios from 'axios'
import { setInterval, clearInterval } from 'timers'
export default {
  name: 'app',
  data() {
    return {
      items: [
        {
          title: 'TimeLine',
          change: () => {
            this.$router.push('/')
          },
        },
        {
          title: 'FavoList',
          change: () => {
            this.$router.push('/favolist')
          },
        },
        {
          title: 'Logout',
          change: () => {
            this.logout()
          },
        },
        {
          title: 'Delete Account',
          change: () => {
            this.dialog1 = true
          },
        },
      ],
      dialog1: false,
      dialog2: false,
      timer: null,
      isVisible: true,
    }
  },
  methods: {
    logout() {
      axios.post('/api/logout').then(() => {
        this.$router.push('/login')
      })
    },
    delAccount() {
      axios.delete('/api/account', { data: {} })
      this.dialog1 = false
      this.dialog2 = true
      this.timer = setInterval(this.changeToLogin, 1000)
    },
    changeToLogin() {
      this.dialog2 = false
      this.$router.push('/login')
    },
  },
  watch: {
    $route: function(to, from) {
      if (to.path === '/' || to.path === '/favolist') {
        this.isVisible = true
      } else if (to.path === '/login' || to.path === '/signup') {
        this.isVisible = false
      }
      if (this.timer !== null) {
        clearInterval(this.timer, 1000)
      }
    },
  },
}
</script>

<style>
.v-card {
  word-wrap: break-word;
}
</style>
