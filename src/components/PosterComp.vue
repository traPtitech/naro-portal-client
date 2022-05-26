<script setup>
import { nextTick, ref, onMounted, onUpdated } from "vue";
import axios from "axios";
import { computed } from "@vue/reactivity";

const newPostBody = ref("");
const posts = ref([]);
const ServerURL = "/api/";
const frame = ref(null);
const postUnits = ref(null);
let isScroll;
// "https://temma.trap.show/naro-todo-server/"
// "http://133.130.109.224:10101/"
// let userName = "userName";
// let userID = "userID";
/* 
axios.get/post/put/delete().then(() => {ここで処理をしないとうまくいかない})
console.log()の下につく黄色い波線は無視して大丈夫そう
*/
const refreshPosts = () => {
  //サーバーデータの一時保存用の配列
  axios
    .get(ServerURL + "/postList")
    .then((response) => {
      posts.value = response.data;

      nextTick(() => {
        frame.value.scrollTop = frame.value.scrollHeight;
      });
      //alert("aa");
    })
    .catch((error) => console.log(error));
  //frame.value.scrollTop = frame.value.scrollHeight;
};

const addPost = () => {
  axios
    .post(ServerURL + "/post", {
      body: newPostBody.value,
    })
    .then(() => {
      newPostBody.value = "";
      refreshPosts();
    })
    .catch((err) => {
      console.log(err);
    });
};
const revercePosts = computed(() => {
  return posts.value.sort((a, b) => {
    if (a.id > b.id) return 1;
    if (a.id < b.id) return -1;
    return 0;
  });
});
onMounted(() => {
  console.log("mounted");
  axios
    .get("/api/whoami")
    .then(() => {
      // userName = response.data.username;
      // userID = response.data.userID;
      refreshPosts();
      //frame.value.scrollTop = frame.value.scrollHeight;
    })
    .catch(refreshPosts);
});

//userName = whoAmI.data.username;
onUpdated(() => {
  if (!isScroll) return;
  //frame.value.scrollTop = frame.value.scrollHeight;
});
</script>

<template>
  <div ref="frame" :class="$style.frame">
    <div v-for="post in revercePosts" :key="post.id" ref="postUnits">
      <div :class="$style.posts">
        <div :class="$style.userName">
          投稿者:{{ post.userName }} / {{ post.postTime }}
        </div>
        <div :class="$style.post">
          <div :class="$style.body">
            <div :class="$style.bodyExp">内容　:</div>
            <div :class="$style.bodyText">{{ post.body }}</div>
          </div>
          <div :class="$style.likesDiv">
            <span :class="$style.likesSpan">
              これすこ:{{ post.likeCount }}人<br />みんな見て!:{{
                post.repostCount
              }}人
            </span>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div>
    <label>
      内容
      <input v-model="newPostBody" :class="$style.input" type="text" />
    </label>
    <button @click="addPost">投稿</button>
  </div>
</template>

<style module>
.frame {
  max-height: 70vh;
  width: 60%;
  min-width: 30rem;
  margin-left: auto;
  margin-right: auto;
  overflow: scroll;
}
.posts {
  text-align: center;
  margin-bottom: 0.3rem;
  border: solid 3px rgb(17, 119, 119);
}
.userName {
  text-align: left;
}
.postBody {
  /* width: 85%; */
  margin-right: auto;
  text-align: left;
}
.post {
  display: flex;
}
.body {
  text-align: left;
  margin-right: 0px;
  display: flex;
  width: calc(100% - 8rem);
}
.likesSpan {
  align-items: flex-end;
  width: auto;
}
.likesDiv {
  display: flex;
  align-items: flex-end;
}
.bodyExp {
  white-space: nowrap;
}
.bodyText {
  overflow-wrap: break-word;
  width: calc(100% - 3rem);
}
.input {
  width: calc(60% - 6rem);
  min-width: 27rem;
}
</style>
