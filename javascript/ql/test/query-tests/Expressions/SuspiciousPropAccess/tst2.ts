(function() {
  let x;
  ({ x } = { x: { p: 42 } });
  x.p;
  
  enum E { a, b }
  E.a;
})();

class C {
  static bar = 2;
  static baz = C.bar + 1;
}
C.foo = 3;


namespace N {
  var x;
  x.p = 5;

  var q = M.Color.Blue; // OK

  namespace M {
    export const enum Color { Blue }
  }
}
