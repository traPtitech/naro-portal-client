import axios from 'axios'
import { createRouter, createWebHistory } from "vue-router";
import HomePage from "./pages/HomePage.vue";
import NotFound from "./pages/NotFound.vue";
import LoginPage from "./pages/LoginPage.vue";
import TwtttPage from "./pages/TwtttPage.vue";

const routes = [
  { path: "/", name: "home", component: HomePage, meta: { isPublic: true } },
  {
    path: "/login",
    name: "login",
    component: LoginPage,
    meta: { isPublic: true },
  },
  { path: "/twttt", name: "twttt", component: TwtttPage },
  { path: "/:path(.*)", component: NotFound, meta: { isPublic: true } },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

router.beforeEach(async (to) => {
  try {
    await axios.get("/api/whoami");
  } catch (_) {
    if (to.meta.isPublic) {
      return true;
    }
    return "/login";
  }
  return true;
});

export default router;
