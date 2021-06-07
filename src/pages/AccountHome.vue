<template>
    <h2>{{ UserID }}</h2>
    <div v-for="tweet in tweets" :key="tweet.datetime">
        <div class="tweet" :class="$style.tweetbox">
            <h4>{{ tweet.userid }} {{ tweet.datetime }}</h4>
            <p>{{ tweet.text }}</p>
        </div>
    </div>
</template>

<style module>
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
import { ref, onMounted } from "vue"
import axios from "axios";

export default {
    props: {
        UserID: {
            type: String,
            required: true
        }
    },
    setup(props){
        const tweets = ref([]);
        onMounted(async () => {
            const res = await axios.get("/api/" + props.UserID)
            tweets.value = res.data
        })
        //const Text = ref("");
        //const postTweet = () => axios.post("api/home", { text: Text.value, });
        return { tweets };
    }
}
</script>