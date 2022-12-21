predicate aPredicate(int i) { none() }

predicate anotherPredicate(int i) { none() }

class SmallInt extends int {
  SmallInt() { this = [0 .. 10] }
}

predicate test() {
  exists(int i | aPredicate(i)) // BAD
  or
  exists(int i | aPredicate(i) or anotherPredicate(i)) // BAD [NOT DETECTED]
  or
  exists(int i | aPredicate(i) and i.abs() = 0) // GOOD
  or
  exists(int i | aPredicate(i) and exists(int i2 | i = i2)) // GOOD
  or
  exists(SmallInt i | aPredicate(i)) // GOOD
}
