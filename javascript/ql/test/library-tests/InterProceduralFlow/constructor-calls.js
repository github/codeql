import * as dummy from 'dummy';

class C {
  constructor() {
    this.field = new Object();
  }
}

function test() {
  let x = new C().field;
  foo(x);
}
