import * as fs from "fs"; // treat file as module

function f() {}
namespace f {
  export function inner() {}
}

f();
f.inner();

class C {}
namespace C {
  export function inner() {}
}

new C();
C.inner();

namespace g {
  export function inner() {}
}

g(); // $ Alert
g.inner();
