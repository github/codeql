<template>
    <p v-html="input"/>
</template>
<script setup lang="ts">
  const { input, numericInput, booleanInput } = defineProps<{
    input: string,
    numericInput: number,
    booleanInput: boolean,
  }>();
</script>
<style>
</style>
