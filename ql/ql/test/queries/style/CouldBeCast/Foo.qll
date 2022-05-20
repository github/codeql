bindingset[i]
predicate foo(int i) {
  exists(Even j | j = i) // NOT OK
  or
  exists(Even j | j = i | j % 4 = 0) // OK
  or
  any(Even j | j = i) = 2 // NOT OK
  or
  any(Even j | j = i | j) = 2 // NOT OK
  or
  any(Even j | j = i | j * 2) = 4 // OK
  or
  any(Even j | j = i and j % 4 = 0 | j) = 4 // OK
  or
  any(int j | j = i) = 2 // NOT OK
  or
  exists(int j | j = i) // NOT OK
}

class Even extends int {
  bindingset[this]
  Even() { this % 2 = 0 }
}
