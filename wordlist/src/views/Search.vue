<template>
  <div>
    <h1>検索画面</h1>
    <input type="text" v-model="searchWord" placeholder="検索ワード" />
    <button @click="search">検索</button>
  </div>
</template>

<script>
export default {
  name: "search"
};
</script>
