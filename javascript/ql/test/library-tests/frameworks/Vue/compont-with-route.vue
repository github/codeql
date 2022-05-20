<template>
    <p v-html="dataA"/>
</template>
<script>
  import Vue from 'vue'
  import Component from 'vue-class-component'
  import { router } from './router';

  @Component({
    watch: {
      '$route.params.id': {
        deep: true,
        handler(newId, oldId) { }
      },
      $route(to, from) { }
    }
  })
  export default class MyComponent extends Vue {
    message = 'Hello!'

    sources() {
      this.$route.params.x;
      this.$route.query.x;
      this.$route.hash.x;
      this.$route.path;
      this.$route.fullPath;
      router.currentRoute.query.x;
    }

    get dataA() {
      return this.$route.query.foo; // NOT OK
    }

    beforeRouteEnter(to, from, next) {
      to.query.x;
      from.query.x;
    }

    beforeRouteUpdate(to, from, next) {
      to.query.x;
      from.query.x;
    }

    beforeRouteLeave(to, from, next) {
      to.query.x;
      from.query.x;
    }
  }
</script>
<style>
</style>
