<template>
    <p v-html="dataA"/>
</template>
<script>
  var x = require('x');
  module.exports = { // not properly detected by the module system yet
    props: ['input'],
    data: function() { return { dataA: 42 + this.input } }
  }
</script>
<style>
</style>