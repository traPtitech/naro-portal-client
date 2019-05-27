import Vue from "vue";
import Router from "vue-router";
import Top from "./views/Top.vue";

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
    }
  ]
});

router.beforeEach(async (to, from, next) => {
  if (to.path === "/login") {
    return next();
  }

  try {
    await fetch("/api/whoami");

    if (to.path === "/") {
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
