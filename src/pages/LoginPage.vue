<script setup>
import axios from "axios";
import { ref } from 'vue';
const username = ref('');
const password = ref('');
const login = () => axios.post("/api/login", {
  "username": username.value, "password": password.value,
});
</script>

<template>
    <div>
        Please Login<br/>
        Username: <input v-model="username" type="text" />
        Password: <input v-model="password" type="password" />
        <button @click="login">login</button>
    </div>
</template>