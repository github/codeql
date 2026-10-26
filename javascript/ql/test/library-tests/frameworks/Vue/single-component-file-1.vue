<template>
    <p v-html="dataA"/>
</template>
<script>
  export default {
    props: ['input'],
    data: function() { return { dataA: 42 + this.input } }
  }
</script>
<style>
</style>