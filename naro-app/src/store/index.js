import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    userData: { userid: "", username: "", biography: "", website: "" }
  },
  getters: {
    userData(state) {
      return state.userData;
    }
  },
  mutations: {
    updateUserData(state, data) {
      state.userData = data;
    }
  },
  actions: {
    updateUserData({ commit }, data) {
      commit("setUserData", { data });
    }
  },
  modules: {}
});
