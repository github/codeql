predicate aPredicate(int i) { none() }

predicate anotherPredicate(int i) { none() }

predicate yetAnotherPredicate(int i, int y) { none() }

predicate dbTypePredicate(@location_default l) { none() }

string predicateWithResult(int i) { none() }

class SmallInt extends int {
  SmallInt() { this = [0 .. 10] }
}

class Location extends @location_default {
  string toString() { result = "" }
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
  exists(int i | count(predicateWithResult(i)) = 0) // GOOD
  or
  exists(int i | count(int y | yetAnotherPredicate(i, y)) > 0) // GOOD
  or
  exists(int i | forex(int y | yetAnotherPredicate(i, y))) // GOOD
  or
  exists(int i | forall(int y | yetAnotherPredicate(i, y))) // GOOD
  or
  exists(SmallInt i | aPredicate(i)) // GOOD
  or
  exists(Location l | dbTypePredicate(l)) // GOOD
}
