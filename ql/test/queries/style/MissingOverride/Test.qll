import ql

class Super extends AstNode {
  predicate test(int i) { i = [1 .. 5] }
}

class Correct extends Super {
  override predicate test(int i) { i = 3 }
}

class Wrong extends Super {
  predicate test(int i) { i = 2 }
}
