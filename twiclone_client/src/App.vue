<template>
  <main>
    <div :class="$style.container">
      <header :class="$style.header">
        <router-link to="/">ホーム</router-link> |
        <router-link to="/timelineall">全体タイムライン</router-link> |
        <div v-if="displayUserID">
          <router-link to="/tweet">つぶやく</router-link> |       
          ログイン中: {{displayUserID}}
          </div>
        <div v-else>
          <router-link to="/login">ログイン</router-link> |
          <router-link to="/signin">サインイン</router-link> |
          ゲスト
          </div>

      </header>

      <router-view />
    </div>
  </main>
</template>

<script>
  import {ref,onMounted} from 'vue';
  import axios from "axios";
export default{
setup(){
  const displayUserID=ref("")
  onMounted(async()=>{
    const res=await axios.get("api/whoami")
    console.log(res.data)
    displayUserID.value=res.data.userid;
  })
  return{displayUserID}
}
};
</script>

<style module>
.container {
  max-width: fit-content;
  margin: auto;
}
.header {
  display: flex;
  justify-content: center;
}
</style>