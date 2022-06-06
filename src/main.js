import { createApp } from "vue";
import App from "./App.vue";
import Router from "./router";
import Markdown from "markdown-it-vue";

createApp(App).use(Router).use(Markdown).mount("#app");
