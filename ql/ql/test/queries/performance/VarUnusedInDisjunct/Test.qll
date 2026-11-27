import ql

class Big = Expr;

class Small extends boolean {
  Small() { this = [true, false] }
}

class MyStr extends string {
  MyStr() { this = ["foo", "bar"] }
}

predicate bad1(Big b) {
  b.toString().endsWith("foo")
  or
  any() // $ Alert
}

int bad2() {
  exists(Big big, Small small |
    result = big.toString().toInt()
    or
    result = small.toString().toInt() // $ Alert
  )
}

float bad3(Big t) {
  result = [1 .. 10].toString().toFloat() or
  result = [11 .. 20].toString().toFloat() or
  result = t.toString().toFloat() or // $ Alert
  result = [21 .. 30].toString().toFloat()
}

string good1(Big t) {
  (
    result = t.toString()
    or
    result instanceof MyStr // <- t unused here, but that's ok because of the conjunct that binds t.
  ) and
  t.toString().endsWith("foo")
}

predicate helper(Big a, Big b) {
  a = b and
  a.toString().endsWith("foo")
}

predicate bad4(Big fromType, Big toType) {
  helper(fromType, toType)
  or
  fromType.toString().endsWith("foo")
  or
  helper(toType, fromType) // $ Alert
}

predicate good2(Big t) {
  exists(Small other |
    t.toString().endsWith("foo")
    or
    other.toString().endsWith("foo") // <- t unused here, but that's ok because of the conjunct (exists) that binds t.
  |
    t.toString().endsWith("foo")
  )
}

predicate mixed1(Big good, Small small) {
  good.toString().endsWith("foo")
  or
  good =
    any(Big bad |
      small.toString().endsWith("foo") and
      // the use of good is fine, the comparison further up binds it.
      // the same is not true for bad.
      (bad.toString().endsWith("foo") or good.toString().startsWith("foo")) and // $ Alert
      small.toString().endsWith("foo")
    )
}

newtype OtherSmall =
  Small1() or
  Small2(boolean b) { b = true } or
  Small3(boolean b, Small o) {
    b = true and
    o.toString().endsWith("foo")
  }

predicate good3(OtherSmall small) {
  small = Small1()
  or
  1 = 1
}

predicate good4(Big big, Small small) {
  big.toString().endsWith("foo")
  or
  // assignment to small type, intentional cartesian product
  small = any(Small s | s.toString().endsWith("foo"))
}

predicate good5(Big bb, Big v, boolean certain) {
  exists(Big read |
    read = bb and
    read = v and
    certain = true
  )
  or
  v =
    any(Big lsv |
      lsv.getEnclosingPredicate() = bb.(Expr).getEnclosingPredicate() and
      (lsv.toString().endsWith("foo") or v.toString().endsWith("foo")) and
      certain = false
    )
}

predicate bad5(Big bb) { if none() then bb.toString().endsWith("foo") else any() } // $ Alert

pragma[inline]
predicate good5(Big a, Big b) {
  // fine. Assumes it's used somewhere where `a` and `b` are bound.
  b = any(Big bb | bb.toString().endsWith("foo"))
  or
  a = any(Big bb | bb.toString().endsWith("foo"))
}

predicate bad6(Big a) {
  (
    a.toString().endsWith("foo") // bad
    or
    any() // $ Alert
  ) and
  (
    a.toString().endsWith("foo") // also bad
    or
    any() // $ Alert
  )
}

predicate good6(Big a) {
  a.toString().endsWith("foo") and
  (
    a.toString().endsWith("foo") // good, `a` is bound on the branch of the conjunction.
    or
    any()
  )
}

predicate good7() {
  exists(Big l, Big r |
    l.toString().endsWith("foo1") and
    r.toString().endsWith("foo2")
    or
    l.toString().endsWith("foo3") and
    r.toString().endsWith("foo4")
  |
    not (l.toString().regexpMatch("%foo5") or r.toString().regexpMatch("%foo6")) and
    (l.toString().regexpMatch("%foo7") or r.toString().regexpMatch("%foo8"))
  )
}

class HasField extends Big {
  Big field;

  HasField() {
    field = this
    or
    this.toString().endsWith("foo") // $ Alert // <- field only defined here.
  }

  Big getField() { result = field }
}
