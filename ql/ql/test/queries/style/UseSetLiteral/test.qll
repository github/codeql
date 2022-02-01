import ql

predicate test1(int a) {
  a = 1 or // BAD
  a = 2 or
  a = 3 or
  a = 4
}

predicate test2(int a) {
  a = [1, 2, 3, 4] // GOOD
}

predicate test3(int a) {
  a = 1 and // GOOD (for the purposes of this query)
  a = 2 and
  a = 3 and
  a = 4
}

bindingset[a]
predicate test4(int a) {
  a < 1 or // GOOD (for the purposes of this query)
  a = 2 or
  a >= 3 or
  a > 4
}

predicate test5() {
  test1(1) or // BAD
  test1(2) or
  test1(3) or
  test1(4)
}

predicate test6() {
  test1(1) or // GOOD
  test2(2) or
  test3(3) or
  test4(4)
}

int test7() {
  1 = result or // BAD
  2 = result or
  3 = result or
  4 = result
}

predicate test8() {
  test7() = 1 or // BAD [NOT DETECTED]
  test7() = 2 or
  test7() = 3 or
  test7() = 4
}

class MyTest8Class extends int {
  string s;

  MyTest8Class() {
    (
      this = 1 or // BAD
      this = 2 or
      this = 3 or
      this = 4
    ) and
    (
      s = "1" or // BAD
      s = "2" or
      s = "3" or
      s = "4"
    ) and
    exists(float f |
      f = 1.0 or // BAD
      f = 1.5 or
      f = 2.0 or
      f = 2.5
    )
  }

  predicate is(int x) { x = this }

  int get() { result = this }
}

predicate test9(MyTest8Class c) {
  c.is(1) or // BAD
  c.is(2) or
  c.is(3) or
  c.is(4)
}

predicate test10(MyTest8Class c) {
  c.get() = 1 or // BAD [NOT DETECTED]
  c.get() = 2 or
  c.get() = 3 or
  c.get() = 4
}

bindingset[a, b, c, d]
predicate test11(int a, int b, int c, int d) {
  a = 1 or // GOOD
  b = 2 or
  c = 3 or
  d = 4
}

bindingset[a, b]
predicate test12(int a, int b) {
  a = 1 or // BAD [NOT DETECTED]
  a = 2 or
  a = 3 or
  a = 4 or
  b = 0
}

predicate test13(int a, int b) {
  a = 1 and b = 1 // GOOD
  or
  a = 2 and b = 4
  or
  a = 3 and b = 9
  or
  a = 4 and b = 16
}

predicate test14(int a) {
  a = 1 // BAD
  or
  (
    (a = 2 or a = 3)
    or
    a = 4
  )
}
