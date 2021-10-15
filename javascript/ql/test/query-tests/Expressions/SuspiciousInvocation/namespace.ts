import * as fs from "fs"; // treat file as module

function f() {}
namespace f {
  export function inner() {}
}

f(); // OK
f.inner(); // OK

class C {}
namespace C {
  export function inner() {}
}

new C(); // OK
C.inner(); // OK

namespace g {
  export function inner() {}
}

g(); // NOT OK
g.inner(); // OK
