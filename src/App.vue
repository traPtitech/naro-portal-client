<template>
  <v-app>
    <v-toolbar class="light-blue lighten-1">
      <v-layout justify-center>
        <v-toolbar-title class="headline">
          <span>TwitterClone</span>
        </v-toolbar-title>
      </v-layout>
    </v-toolbar>

    <v-container>
      <router-view />
    </v-container>
  </v-app>
</template>

<style>
span,
h1 {
  color: white;
}
#bottun {
  color: #4fc3f7;
}
</style>
