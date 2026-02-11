<template>
    <p v-html="input"/>
</template>
<script setup>
  const { input, numericInput, booleanInput } = defineProps({
    input: String,
    numericInput: Number,
    booleanInput: Boolean,
  });
</script>
<style>
</style>
