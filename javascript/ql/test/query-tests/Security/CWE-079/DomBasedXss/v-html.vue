<template>
    <p v-html="tainted"/> <!-- $ Alert -->
</template>
<script>
  export default {
    data: function() { return { tainted: document.location } } // $ Source
  }
</script>
<style>
</style>