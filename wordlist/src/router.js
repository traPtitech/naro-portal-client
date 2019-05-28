import Vue from "vue";
import Router from "vue-router";
import Home from "./views/Home.vue";
import Login from "./views/Login.vue";
import SignUp from "./views/SignUp.vue";
import Search from "./views/Search.vue";
import WordInfo from "./views/WordInfo.vue";
import User from "./views/User.vue";
import Group from "./views/Group.vue";
import Welcome from "./views/Welcome.vue";

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: "/",
      name: "home",
      component: Home
    },
    {
      path: "/login",
      name: "login",
      component: Login
    },
    {
      path: "/signUp",
      name: "signUp",
      component: SignUp
    },
    {
      path: "/search",
      name: "search",
      component: Search
    },
    {
      path: "/wordInfo/:word",
      name: "wordInfo",
      component: WordInfo
    },
    {
      path: "/user/:userName",
      name: "user",
      component: User
    },
    {
      path: "/group/:groupName",
      name: "group",
      component: Group
    },
    {
      path: "/welcome",
      name: "welcome",
      component: Welcome
    },
    {
      path: "/about",
      name: "about",
      // route level code-splitting
      // this generates a separate chunk (about.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      component: () =>
        import(/* webpackChunkName: "about" */ "./views/About.vue")
    }
  ]
});
