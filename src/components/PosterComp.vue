<script setup>
import { nextTick, ref, onMounted, onUpdated } from "vue";
import axios from "axios";
import { computed } from "@vue/reactivity";
//import MarkdownItVue from "markdown-it-vue";
import "markdown-it-vue/dist/markdown-it-vue.css";
import VueMarkdownIt from "vue3-markdown-it";
import "highlight.js/styles/monokai.css";
import markdownItLatex from "markdown-it-latex";
import markdownItContainer from "markdown-it-container";
import markdownItKatex from "markdown-it-katex";
//import markdownItImsize from "markdown-it-imsize";
//import MarkdownItSup from "markdown-it-sup";
//import MdEditor from "md-editor-v3";
import MarkdownItStrikethroughAlt from "markdown-it-strikethrough-alt";
import "md-editor-v3/lib/style.css";

// let tm = require("markdown-it-texmath");
// let md = require("markdown-it")().use(tm, {
//   engine: require("katex"),
//   delimiters: "dollars",
// });

const newPostBody = ref("");
const posts = ref([]);
const ServerURL = "/api/";
const frame = ref(null);
const postUnits = ref(null);
let isScroll;
//const content = "# your markdown content";
const plugins = [
  {
    plugin: markdownItLatex,
  },
  {
    plugin: markdownItKatex,
  },
  {
    plugin: markdownItContainer,
  },
  {
    plugin: MarkdownItStrikethroughAlt,
  },
];
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
  console.log(newPostBody.value);
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
        <div :class="$style.uNameAndBody">
          <div :class="$style.userName">
            投稿者:{{ post.userName }} / {{ post.postTime }}
          </div>
          <div :class="$style.post">
            <div :class="$style.body">
              <div :class="$style.bodyExp">内容　:</div>
              <!-- <div :class="$style.bodyText">{{ post.body }}</div> -->
              <VueMarkdownIt
                :breaks="true"
                :class="$style.bodyText"
                :html="true"
                :plugins="plugins"
                :source="post.body"
              />
            </div>
          </div>
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
  <div>
    <label>
      内容
      <textarea v-model="newPostBody" :class="$style.input" type="text" />
    </label>
    <button @click="addPost">投稿</button>
    <!-- <MarkdownItVue class="md-body" :content="content" /> -->
    <!-- <VueMarkdownIt class="md-body" :source="content" /> -->
  </div>
  <!-- <div v-html="md.render(content)"></div> -->
</template>

<style module>
* {
  margin-block-start: 0rem;
  margin-block-end: 0rem;
  margin-inline-start: 0px;
  margin-inline-end: 0px;
}
.frame {
  max-height: calc(95vh - 6.5rem);
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
  display: flex;
  align-items: flex-end;
}
.userName {
  text-align: left;
  overflow-wrap: break-word;
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
  width: 100%;
}
.likesSpan {
  align-items: flex-end;
  width: auto;
  text-align: left;
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
  margin-bottom: auto;
}
.input {
  width: calc(60% - 6rem);
  height: 3.5rem;
  min-width: 26rem;
}
.uNameAndBody {
  width: calc(100% - 10rem);
}
</style>
