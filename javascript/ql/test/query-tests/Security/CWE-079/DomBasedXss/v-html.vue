<template>
    <p v-html="tainted"/>
</template>
<script>
  export default {
    data: function() { return { tainted: document.location } }
  }
</script>
<style>
</style>