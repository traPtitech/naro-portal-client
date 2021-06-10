import { createRouter, createWebHistory } from "vue-router";
import Login from "./pages/Login.vue";
import Home from "./pages/Home.vue";
import AccountHome from "./pages/AccountHome.vue";

const routes = [
  { path: "/login", component: Login },
  { path: "/", component: Home },
  { path: "/:UserID", component: AccountHome, props: true },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;