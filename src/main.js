import Vue from "vue";
import ElementUI from "element-ui";
import locale from "element-ui/lib/locale/lang/ja";
import App from "./App.vue";
import router from "./router";
import "./plugins/element.js";
import store from "./store";
global.Vue = Vue;

Vue.config.productionTip = false;
Vue.use(ElementUI, { locale });
new Vue({
  router,
  store,
  render: h => h(App)
}).$mount("#app");
