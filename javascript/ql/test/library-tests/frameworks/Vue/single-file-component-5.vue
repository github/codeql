<template>
    <p v-html="dataA"/>
</template>
<script>
  import Vue from 'vue'
  import Component from 'vue-class-component'

  @Component
  export default class MyComponent extends Vue {
    message: string = 'Hello!'

    get dataA() {
      return 42;
    }
  }
</script>
<style>
</style>
