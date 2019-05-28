import Vue from "vue";
import "./plugins/vuetify";
import Axios from "axios";
import App from "./App.vue";
import router from "./router";
import store from "./store";

Axios.defaults.withCredentials = true;

Vue.config.productionTip = false;

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount("#app");
