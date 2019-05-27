import Vue from "vue";
import Router from "vue-router";
import { AuthsApi } from "./api";
import Top from "./views/Top.vue";

const api = new AuthsApi();

Vue.use(Router);

const router = new Router({
  routes: [
    {
      path: "/",
      name: "top",
      component: Top
    },
    {
      path: "/home",
      name: "home",
      component: () => import("./views/Home.vue")
    },
    {
      path: "/login",
      name: "login",
      component: () => import("./views/Login.vue")
    },
    {
      path: "/register",
      name: "register",
      component: () => import("./views/Register.vue")
    },
    {
      path: "/users/:id",
      name: "users",
      component: () => import("./views/User.vue")
    }
  ]
});

router.beforeEach(async (to, from, next) => {
  if (["/login", "/register"].includes(to.path)) {
    return next();
  }

  try {
    await api.whoami();

    if (["/", "/login", "/register"].includes(to.path)) {
      return next("/home");
    }
  } catch {
    if (to.path === "/") {
      return next();
    }
    return next("/login");
  }
  next();
});

export default router;
