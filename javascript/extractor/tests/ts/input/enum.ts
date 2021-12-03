enum Color { red = 1, green, blue }

declare enum DeclaredEnum { a, b }
const enum ConstEnum { a = 1+2, b }
declare const enum DeclaredConstEnum { a, b }

function foo(x) { return x; }

enum ComplexInitializer {
  a = foo(1 + 2)
}

enum StringLiteralEnumMember {
  "a" = 2,
  b = a
}

var x : StringLiteralEnumMember.a = 2
