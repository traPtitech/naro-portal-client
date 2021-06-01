import { createRouter, createWebHistory } from "vue-router";
import Home from "./pages/Home.vue";
import NotFound from "./pages/NotFound.vue";
import Login from "./pages/Login.vue";
import Signin from "./pages/Signin.vue";

const routes = [
  { 
    path: "/", 
    name:"home",
    component: Home
  },
  { 
    path: "/login",
    name:"login",
    component: Login 
  },
  { 
    path: "/signin",
    name:"signin",
    component: Signin 
  },
  { path: "/:path(.*)", component: NotFound },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;