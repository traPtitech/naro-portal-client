import axios from 'axios'
import Vue from 'vue'
import Router from 'vue-router'
import Login from './components/login'
import Signup from './components/signup'
import Timeline from './components/timeline'

Vue.use(Router)

const router = new Router({
  routes: [
    {
      path: '/login',
      name: 'login',
      component: Login,
      meta: {
        isPublic: true,
      },
    },
    {
      path: '/',
      name: 'timeline',
      component: Timeline,
    },
    {
      path: '/signup',
      name: 'signup',
      component: Signup,
      meta: {
        isPublic: true,
      },
    },
  ],
})

router.beforeEach(async (to, from, next) => {
  try {
    await axios.get('/api/whoAmI')
  } catch (_) {
    if (to.meta.isPublic) {
      return next(true)
    }
    return next('/login')
  }
  next(true)
})

export default router
