import axios from 'axios'
import Vue from 'vue'
import Router from 'vue-router'
import Login from './components/login'
import Timeline from './components/timeline'

Vue.use(Router)

const router = new Router({
  routes: [
    {
      path: '/',
      name: 'login',
      component: Login,
      meta: {
        isPublic: true,
      },
    },
    {
      path: '/timeline',
      name: 'timeline',
      component: Timeline,
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
    return next('/')
  }
  next(true)
})

export default router
