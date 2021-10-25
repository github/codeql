(function() {
  class A {
    hello() {
      console.log("Hello");
    }

    m() {
      this.hello();
    }
  }

  class B extends A {
    hello() {
      console.log("Hello!");
    }
  }

  new B().hello();
});