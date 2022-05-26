<script setup>
import { ref, onMounted } from "vue";
import axios from "axios";

const newTodoName = ref("");
const newTodoDeadline = ref("");
const completedTasks = ref([]);
const uncompletedTasks = ref([]);
const ServerURL = "/api/";
// "https://temma.trap.show/naro-todo-server/"
// "http://133.130.109.224:10101/"
let userName = "userName";
/* 
axios.get/post/put/delete().then(() => {ここで処理をしないとうまくいかない})
console.log()の下につく黄色い波線は無視して大丈夫そう
*/
const refreshTasks = () => {
  const tasks = ref([]); //サーバーデータの一時保存用の配列
  axios
    .get(ServerURL + userName + "/tasks")
    .then((response) => {
      tasks.value = response.data;
      if (!tasks.value && !tasks.value[0]) return;
      completedTasks.value = [];
      uncompletedTasks.value = []; //一旦配列を空にする
      for (let i = 0; i < tasks.value.length; i++) {
        if (tasks.value[i].isCompleted) {
          completedTasks.value.push(tasks.value[i]);
        } else {
          uncompletedTasks.value.push(tasks.value[i]);
        } //isCompleteの値で達成/未達成の配列に振り分ける
      }
    })
    .catch((error) => console.log(error));
};

const addTask = () => {
  const time = new Date().getTime();
  axios
    .post(ServerURL + userName + "/tasks", {
      id: String(time), //登録した時の時間をidとして設定してる
      name: newTodoName.value,
      deadline: newTodoDeadline.value,
      isCompleted: false,
      traQID: userName,
    })
    .then(() => {
      refreshTasks();
    })
    .catch((err) => {
      console.log(err);
    });
};
const completeTask = (name, deadline, id) => {
  axios
    .put(ServerURL + userName + "/tasks/" + id, {
      id: id,
      name: name,
      deadline: deadline,
      isCompleted: true,
      traQID: userName,
    }) //isCompleteの値を更新,実はcompleteTaskとuncompleteTaskは統合できる
    .then(() => {
      refreshTasks();
    })
    .catch((err) => {
      console.log(err);
    });
};
const uncompleteTask = (name, deadline, id) => {
  axios
    .put(ServerURL + userName + "/tasks/" + id, {
      id: id,
      name: name,
      deadline: deadline,
      isCompleted: false,
      traQID: userName,
    })
    .then(() => {
      refreshTasks();
    })
    .catch((err) => {
      console.log(err);
    });
};
const deleteTask = (id) => {
  axios
    .delete(ServerURL + userName + "/tasks/" + id)
    .then(() => {
      refreshTasks();
    })
    .catch((err) => {
      console.log(err);
    });
};
const deleteAllTask = () => {
  axios
    .delete(ServerURL + userName + "/tasks")
    .then(() => {
      refreshTasks();
    })
    .catch((err) => {
      console.log(err);
    });
};
onMounted(() => {
  console.log("mounted");
  axios
    .get("/api/whoami")
    .then((response) => {
      userName = response.data.username;
      refreshTasks();
    })
    .catch(refreshTasks);
  //userName = whoAmI.data.username;
});
</script>

<template>
  <div v-for="task in uncompletedTasks" :key="task.name">
    <div class="task">
      <span class="name list">名前: {{ task.name }}</span>
      <span class="deadline list">期限: {{ task.deadline }}</span>
      <button
        class="complete"
        @click="completeTask(task.name, task.deadline, task.id)"
      >
        完了
      </button>
    </div>
  </div>
  <div>
    <label>
      名前
      <input v-model="newTodoName" type="text" />
    </label>
    <label>
      期限
      <input v-model="newTodoDeadline" type="text" />
    </label>
    <button @click="addTask">追加</button>
  </div>
  <div class="cTask">終わったタスク</div>
  <div v-for="cTask in completedTasks" :key="cTask.name" class="cTask">
    <div class="task">
      <span class="name list">名前: {{ cTask.name }}</span>
      <span class="deadline list">期限: {{ cTask.deadline }}</span>
      <button class="delete" @click="deleteTask(cTask.id)">削除</button>
      <button
        class="uncomplete"
        @click="uncompleteTask(cTask.name, cTask.deadline, cTask.id)"
      >
        終わってなかった!
      </button>
    </div>
  </div>
  <div>
    <button class="complete" @click="deleteAllTask()">全消去</button>
  </div>
</template>

<style>
.over500 {
  color: red;
}
.list {
  margin: 1rem;
}
.cTask {
  color: gray;
}
.delete {
  color: yellow;
  background-color: red;
}
.uncomplete {
  color: red;
}
.complete {
  color: black;
  background-color: dodgerblue;
}
button {
  border-radius: 50vh;
}
</style>
