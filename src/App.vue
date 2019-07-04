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
  </v-app>
</template>

<script>
import axios from 'axios'
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
      ],
      isVisible: true,
    }
  },
  methods: {
    logout() {
      axios.post('/api/logout').then(() => {
        this.$router.push('/login')
      })
    },
  },
  watch: {
    $route: function(to, from) {
      if (to.path === '/' || to.path === '/favolist') {
        this.isVisible = true
      } else if (to.path === '/login') {
        this.isVisible = false
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
