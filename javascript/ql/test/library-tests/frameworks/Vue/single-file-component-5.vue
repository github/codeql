<template>
    <p v-html="dataA"/>
</template>
<script>
  import Vue from 'vue'
  import Component from 'vue-class-component'
  import { Prop } from 'vue-property-decorator'

  @Component
  export default class MyComponent extends Vue {
    message: string = 'Hello!'
    @Prop() input: string;

    get dataA() {
      return 42;
    }

    get dataB() {
      return this.input;
    }
  }
</script>
<style>
</style>
