<template>
  <v-app>
    <v-toolbar class="light-blue lighten-1">
      <v-layout justify-center>
        <v-toolbar-title class="headline white--text">
          TwitterClone
        </v-toolbar-title>
      </v-layout>
    </v-toolbar>

    <v-container>
      <router-view />
    </v-container>
  </v-app>
</template>

<style>
.v-card {
  word-wrap: break-word;
}
</style>
