<template>
    <p v-html="input"/>
</template>
<script setup>
  const { input } = defineProps(['input']);
</script>
<style>
</style>
