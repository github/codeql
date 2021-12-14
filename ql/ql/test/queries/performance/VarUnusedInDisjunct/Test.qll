import ql

class Big = Expr;

class Small extends boolean {
  Small() { this = [true, false] }
}

class MyStr extends string {
  MyStr() { this = ["foo", "bar"] }
}

predicate bad1(Big b) {
  b.toString().matches("%foo")
  or
  any()
}

int bad2() {
  exists(Big big, Small small |
    result = big.toString().toInt()
    or
    result = small.toString().toInt()
  )
}

float bad3(Big t) {
  result = [1 .. 10].toString().toFloat() or
  result = [11 .. 20].toString().toFloat() or
  result = t.toString().toFloat() or
  result = [21 .. 30].toString().toFloat()
}

string good1(Big t) {
  (
    result = t.toString()
    or
    result instanceof MyStr // <- t unused here, but that's ok because of the conjunct that binds t.
  ) and
  t.toString().regexpMatch(".*foo")
}

predicate helper(Big a, Big b) {
  a = b and
  a.toString().matches("%foo")
}

predicate bad4(Big fromType, Big toType) {
  helper(fromType, toType)
  or
  fromType.toString().matches("%foo")
  or
  helper(toType, fromType)
}

predicate good2(Big t) {
  exists(Small other |
    t.toString().matches("%foo")
    or
    other.toString().matches("%foo") // <- t unused here, but that's ok because of the conjunct (exists) that binds t.
  |
    t.toString().regexpMatch(".*foo")
  )
}

predicate mixed1(Big good, Small small) {
  good.toString().matches("%foo")
  or
  good =
    any(Big bad |
      small.toString().matches("%foo") and
      // the use of good is fine, the comparison futher up binds it.
      // the same is not true for bad.
      (bad.toString().matches("%foo") or good.toString().regexpMatch("foo.*")) and
      small.toString().regexpMatch(".*foo")
    )
}

newtype OtherSmall =
  Small1() or
  Small2(boolean b) { b = true } or
  Small3(boolean b, Small o) {
    b = true and
    o.toString().matches("%foo")
  }

predicate good3(OtherSmall small) {
  small = Small1()
  or
  1 = 1
}

predicate good4(Big big, Small small) {
  big.toString().matches("%foo")
  or
  // assignment to small type, intentional cartesian product
  small = any(Small s | s.toString().matches("%foo"))
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
      (lsv.toString().matches("%foo") or v.toString().matches("%foo")) and
      certain = false
    )
}

predicate bad5(Big bb) { if none() then bb.toString().matches("%foo") else any() }

pragma[inline]
predicate good5(Big a, Big b) {
  // fine. Assumes it's used somewhere where `a` and `b` are bound.
  b = any(Big bb | bb.toString().matches("%foo"))
  or
  a = any(Big bb | bb.toString().matches("%foo"))
}

predicate bad6(Big a) {
  (
    a.toString().matches("%foo") // bad
    or
    any()
  ) and
  (
    a.toString().matches("%foo") // also bad
    or
    any()
  )
}

predicate good6(Big a) {
  a.toString().matches("%foo") and
  (
    a.toString().matches("%foo") // good, `a` is bound on the branch of the conjunction.
    or
    any()
  )
}

predicate good7() {
  exists(Big l, Big r |
    l.toString().matches("%foo1") and
    r.toString().matches("%foo2")
    or
    l.toString().matches("%foo3") and
    r.toString().matches("%foo4")
  |
    not (l.toString().regexpMatch("%foo5") or r.toString().regexpMatch("%foo6")) and
    (l.toString().regexpMatch("%foo7") or r.toString().regexpMatch("%foo8"))
  )
}

// TOOD: Next test, this one is
string good8(int bitSize) {
  if bitSize != 0
  then bitSize = 1 and result = bitSize.toString()
  else (
    if 1 = 0 then result = "foo" else result = "bar"
  )
}
