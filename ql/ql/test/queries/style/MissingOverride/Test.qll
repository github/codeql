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

class Mid extends Super { }

class Wrong2 extends Mid {
  predicate test(int i) { i = 2 }
}

final class SuperFinal = Super;

class Correct2 extends SuperFinal {
  predicate test(int i) { i = 4 }
}

class Correct3 extends AstNode instanceof SuperFinal {
  predicate test(int i) { i = 4 }
}

final class Super2 extends AstNode {
  predicate test(int i) { i = [1 .. 5] }
}

class Correct4 extends Super2 {
  predicate test(int i) { i = 3 }
}
