import Vue from "vue";
import VueRouter from "vue-router";
import Profile from "../views/Profile.vue";
import EditProfile from "../views/EditProfile.vue";
import Following from "../views/Following.vue";
import Followers from "../views/Followers.vue";
import Home from "../views/Home.vue";
import Login from "../views/Login.vue";
import axios from "axios";

Vue.use(VueRouter);

const routes = [
  {
    path: "/profile/:userId",
    name: "Profile",
    component: Profile,
    props: true
  },
  {
    path: "/editProfile",
    name: "EditProfile",
    component: EditProfile,
    props: true
  },
  {
    path: "/:userId/following",
    name: "Following",
    component: Following,
    props: true
  },
  {
    path: "/:userId/followers",
    name: "Followers",
    component: Followers,
    props: true
  },
  {
    path: "/",
    name: "Home",
    component: Home,
    props: true
  },
  {
    path: "/login",
    name: "Login",
    component: Login,
    props: true,
    meta: {
      isPublic: true
    }
  }
];

const router = new VueRouter({
  routes
});

router.beforeEach(async (to, from, next) => {
  try {
    await axios.get("/api/whoami");
  } catch (_) {
    if (to.path === "/login") {
      return next(true);
    }
    return next("/login");
  }
  next(true);
});

export default router;
