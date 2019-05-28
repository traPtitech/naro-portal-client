import Vue from "vue";
import Router from "vue-router";
import Home from "./views/Home.vue";
import Login from "./views/login.vue";
import Signup from "./views/signup.vue";
import Axios from "./views/Axios.vue";
import Review from "./views/review.vue";
import Show from "./views/show.vue";
import Myreviews from "./views/myreviews.vue";
import Myfav from "./views/myfav.vue";
import Title from "./views/title.vue";
import User from "./views/user.vue";
Vue.use(Router);

const router = new Router({
  routes: [
    {
      path: "/",
      name: "home",
      component: Home,
      meta: {
        isPublic: true
      }
    },
    {
      path: "/axios",
      name: "axios",
      component: Axios,
      meta: {
        isPublic: true
      }
    },
    {
      path: "/myreviews",
      name: "myreviews",
      component: Myreviews,
      meta: {
        isPublic: true
      }
    },
    {
      path: "/login",
      name: "login",
      component: Login,
      meta: {
        isPublic: true
      }
    },
    {
      path: "/show",
      name: "show",
      component: Show,
      meta: {
        isPublic: true
      }
    },
    {
      path: "/about",
      name: "about",
      // route level code-splitting
      // this generates a separate chunk (about.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      component: () =>
        import(/* webpackChunkName: "about" */ "./views/About.vue")
    },
    {
      path: "/review",
      name: "review",
      component: Review,
      meta: {
        isPublic: true
      }
    },
    {
      path: "/myfav",
      name: "myfav",
      component: Myfav,
      meta: {
        isPublic: true
      }
    },
    {
      path: "/signup",
      name: "signup",
      component: Signup,
      meta: {
        isPublic: true
      }
    },
    // {
    //   path: "/signup",
    //   name: "Country",
    //   component: Country,
    //   meta: {
    //     isPublic: true
    //   }
    // },
    {
      path: "/titles/:titleName",
      name: "Title",
      component: Title,
      meta: {
        isPublic: true
      }
    },
    {
      path: "/users/:userName",
      name: "User",
      component: User,
      meta: {
        isPublic: true
      }
    }
  ]
});

// router.beforeEach(async (to, from, next) => {
//   try {
//     await axios.get("/api/whoami");
//   } catch (_) {
//     if (to.meta.isPublic) {
//       return next(true);
//     }
//     return next("/login");
//   }
//   next(true);
// });

export default router;
