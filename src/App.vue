<template>
  <div id="app">
    <div class="header">
      <div class="header-left" @click="pushTo('/')">Home</div>
      <div class="header-left" @click="pushTo('/about')">About</div>
    </div>
    <div class="body">
      <router-view />
    </div>
  </div>
</template>

<script>
export default {
  name: "App",
  methods: {
    pushTo(url) {
      this.$router.push(url);
    }
  }
};
</script>

<style>
#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
}

.header {
  height: 50px;
  width: 100%;
  padding: 0 20px;
  border-bottom: 1px solid #eee;
  position: fixed;
  top: 0;
  z-index: 10;

  display: flex;
}

.header a {
  font-weight: bold;
  color: #2c3e50;
}

.header a.router-link-exact-active {
  color: #42b983;
}

.header-left {
  line-height: 50px;
  padding: 0 25px;
  color: rgba(0, 0, 0, 0.5);
  cursor: pointer;
}

.header-left:hover {
  color: rgba(0, 0, 0, 0.8);
  transition: all 0.5s;
}

.body {
  padding: 50px 0 50px 0;
  text-align: center;
}
</style>
