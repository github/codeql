
export class D {
  static bar = 2;
  static baz = D.bar + 1;
}
D.foo = 3;

let obj = {};
obj.foo = 4;

function foo() { return D; }
