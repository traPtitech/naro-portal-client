import { createRouter, createWebHistory } from "vue-router";

import axios from 'axios';

import Home from "./pages/Home.vue";
import NotFound from "./pages/NotFound.vue";
import Login from "./pages/Login.vue";
import Signin from "./pages/Signin.vue";
import TimeLineAll from "./pages/TimeLineAll.vue";
import Tweet from "./pages/Tweet.vue";
const routes = [
  { 
    path: "/", 
    name:"home",
    component: Home,
    meta:{
      isPublic:true,
      forGuestOnly:false
    }
  },
  { 
    path: "/login",
    name:"login",
    component: Login ,
    meta:{
      isPublic:true,
      forGuestOnly:true
    }
  },
  { 
    path: "/signin",
    name:"signin",
    component: Signin ,
    meta:{
      isPublic:true,
      forGuestOnly:true
    }
  },
  { 
    path: "/timelineall",
    name:"timelineall",
    component: TimeLineAll ,
    meta:{
      isPublic:true,
      forGuestOnly:false
    }
  },
  { 
    path: "/tweet",
    name:"tweet",
    component: Tweet ,
    meta:{
      isPublic:false,
      forGuestOnly:false
    }
  },
  { 
    path: "/:path(.*)", 
    component: NotFound,
    meta:{
      isPublic:true,
      forGuestOnly:false
    }
   },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

router.beforeEach(async (to, from) => {
  try {
    await axios.get("/api/whoami");

    if (to.meta.forGuestOnly) {
      return "/timelineall";
    }
    return true;

    } catch (_) {
    if (to.meta.isPublic) {
      return true;
    }
    return "/login";
  }
});


export default router;