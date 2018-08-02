function registerSomething(x) {
  x.foo();
}

namespace a.b.q {
  var c = {
    foo
  };

  registerSomething(c);

  function foo() {} // OK
}
