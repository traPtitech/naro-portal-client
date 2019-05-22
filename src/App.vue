<template lang="pug">
  #app
    v-toolbar
      v-toolbar-side-icon
      v-toolbar-title Title
      v-spacer
      v-btn(icon)
        v-icon search
      v-btn(icon)
        v-icon apps
      v-btn(icon)
        v-icon refresh
      v-btn(icon)
        v-icon more_vert
    #nav
      router-link(to="/") Home
      | |
      router-link(to="/about") About
    router-view
</template>

<style lang="stylus">
@import url('https://fonts.googleapis.com/icon?family=Material+Icons')

#app
  font-family: 'Avenir', Helvetica, Arial, sans-serif
  -webkit-font-smoothing: antialiased
  -moz-osx-font-smoothing: grayscale
  text-align: center
  color: #2c3e50

#nav
  padding: 30px

  a
    font-weight: bold
    color: #2c3e50

    &.router-link-exact-active
      color: #42b983
</style>
