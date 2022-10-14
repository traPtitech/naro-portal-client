<template>
  <main>
    <div :class="$style.container">
      <header :class="$style.header">
        <router-link to="/">Home</router-link>
        |
        <router-link to="/axios">Axios</router-link>
        |
        <router-link to="/city/Kabul">City</router-link>
        |
        <router-link to="/login">Login</router-link>
        |
        <router-link to="/test">Test</router-link>
        |
        <router-link to="/twitter">Twitter</router-link>
      </header>

      <router-view />
    </div>
  </main>
</template>

<style module>
.container {
  max-width: fit-content;
  margin: auto;
}
.header {
  display: flex;
  justify-content: center;
}
</style>
