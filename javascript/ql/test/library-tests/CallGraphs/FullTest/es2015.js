class ExampleClass {
  constructor() {
    console.log("hi");
  }
}
new ExampleClass();

!function () {
  return () => {
    arguments.callee();
  };
}

class Sub extends ("Wait for it", ExampleClass) {
  constructor() {
    super();
  }
}

function PseudoClass() {
  this.x = 42;
}

class OtherSub extends PseudoClass {
  constructor() {
    super();
    console.log(this.x);
  }
}

function sum(x, y, z) {
  return x+y+z;
}
sum(...[1, 2, 3]);
sum(1, ...[2, 3]);
sum(1, ...[2], 3);
