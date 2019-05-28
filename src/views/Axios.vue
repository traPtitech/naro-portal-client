<template>
  <div>
    <button @click="sendGet">get</button>
    <button @click="sendPost">post</button>
    <button @click="sendPut">put</button>
    <button @click="sendDelete">delete</button>
  </div>
</template>

<script>
import axios from "axios";
export default {
  name: "Axios",
  methods: {
    sendGet() {
      axios.get("https://en9w9zg03ut1p.x.pipedream.net");
    },
    sendPost() {
      axios.post("https://en9w9zg03ut1p.x.pipedream.net", {
        traQID: "ryoha",
        grade: 19
      });
    },
    sendPut() {
      axios.put("https://en9w9zg03ut1p.x.pipedream.net", {
        testData: { string: "string", number: 1 }
      });
    },
    sendDelete() {
      axios.delete("https://en9w9zg03ut1p.x.pipedream.net", {
        data: { po: 1 }
      });
    }
  }
};
</script>
