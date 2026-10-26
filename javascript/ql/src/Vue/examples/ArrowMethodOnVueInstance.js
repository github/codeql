new Vue({
  data: {
    myProperty: 42
  },
  created: () => {
    // BAD: prints: "myProperty is: undefined"
    console.log('myProperty is: ' + this.myProperty);
  }
});

new Vue({
  data: {
    myProperty: 42
  },
  created: function () {
    // GOOD: prints: "myProperty is: 1"
    console.log('myProperty is: ' + this.myProperty);
  }
});
