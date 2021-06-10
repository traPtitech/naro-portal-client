<template>
    <main>
    <div :class="$style.container">
        <header :class="$style.header">
            <router-link to="/">Home</router-link>
            |
            <router-link to="/login">Login</router-link>
        </header>

        <router-view />
    </div></main>
    <!--<img alt="Vue logo" src="./assets/logo.png" />
    <HelloWorld msg="Hello Vue 3 + Vite" />
    <Home />-->
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