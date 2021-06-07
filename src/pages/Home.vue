<template>
    <h2>Home</h2>
    <img alt="Vue logo" src="../assets/logo.png" />
    <HelloWorld msg="Hello Vue 3 + Vite" />
    <div v-for="tweet in tweets" :key="tweet.datetime">
        <div class="tweet">
            {{ tweet.userid }}
            {{ tweet.datetime }}
            {{ tweet.text }}
        </div>
    </div>
</template>

<script>
import { ref, onMounted } from "vue"
import axios from "axios";

import HelloWorld from "../components/HelloWorld.vue";

export default {
    components: {
        HelloWorld,
    },
    setup(){
        const tweets = ref([]);
        onMounted(async () => {
            const res = await axios.get("/api/home")
            tweets.value = res.data
        })
        /*
        //var tweets = ref([])
        const ret = await axios.get("/api/home", tweets)
        const tweets = ret.data
            .then(response => {
                var tweets = response.data
            })*/
        return { tweets }
    }
}
</script>