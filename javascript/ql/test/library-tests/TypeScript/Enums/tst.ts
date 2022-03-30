enum E { A = 1, B }

const enum ConstEnum { a = 1+2, b }

declare enum DeclaredEnum { a, b }
declare const enum DeclaredConstEnum { a, b }

namespace Q {
  export const enum ExportedConstEnum { a, b }
}

function foo(x) { return x; }

enum NoInitializers {
  a, b, c
}

enum PartiallyInitialized {
  a = 1, b, c
}

enum ComplexInitializer {
  a = 1,
  b = foo(2 + 3),
  c = 2,
  d = 3
}


var valueAccess = E.A
var memberType: E.A
var enumType: E

var x = 'x'
enum LocalReference {
  x,
  y = x+1
}

enum StringLiteralMembers {
  "x",
  y = x+1,
  "\x41", // A
  z = A+1
}
