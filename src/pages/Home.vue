<template>
    <h2>Home</h2>
    <button @click="toAccountHome">button</button>
    <div>
        <textarea v-model="Text" type="text" :class="$style.tweetarea" v-on:keydown.ctrl.enter="postTweet" />
        <button @click="postTweet">Tweet</button>
    </div>
    <div v-for="tweet in tweets" :key="tweet.datetime">
        <div class="tweet" :class="$style.tweetbox" @click="toAccountHome(tweet.userid)">
            <h4>
                <!--<span @click="toAccountHome(tweet.userid)">{{ tweet.userid }}</span>-->
                <router-link :to="`/${tweet.userid}`">{{ tweet.userid }}</router-link>
                &nbsp;
                <span style="font-size: 12px">{{ tweet.datetime }}</span>
            </h4>
            <p>{{ tweet.text }}</p>
        </div>
    </div>
</template>

<style module>
.tweetarea {
    height: 60px;
    width: 500px;
}
.tweetbox {
    width: 700px;
    padding: 0.5em 0.5em 1em 1em;
    margin: 1em 0;
    font-weight: bold;
    color: #6091d3;/*文字色*/
    background: #FFF;
    border: solid 3px #6091d3;/*線*/
    border-radius: 10px;/*角の丸み*/
    overflow-wrap: break-word;
}
</style>

<script>
import { ref, onMounted, onBeforeUnmount } from "vue"
import axios from "axios";

export default {
    setup(){
        const tweets = ref([])
        const id = ref(0)
        onMounted(() => {
            id.value = setInterval(
                async () => {
                    const res = await axios.get("/api/home")
                    tweets.value = res.data
                },
                3000
            )
        })
        /*
        //var tweets = ref([])
        axios.get("/api/home", tweets)
        const tweets = ret.data
            .then(response => {
                var tweets = response.data
            })*/
        const Text = ref("");
        const postTweet = () => {
            axios.post("api/home", { text: Text.value, });
            Text.value = "";
        }

        //const userid = ref("")
        //const toAccountHome = (userid) => router.push("api/" + userid)
        const toAccountHome = () => {
            console.log("hello")
            this.$router.push('/season')
        }
        /*onBeforeUnmount(() => {
            clear.Interval(id)
        })*/
        return { tweets, id, Text, postTweet, toAccountHome };
    }
}
</script>