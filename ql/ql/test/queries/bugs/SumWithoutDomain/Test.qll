// Result is 3 and not 4
int foo() {
  result = sum([1, 1, 2]) // <- Alert here
}

// Ok - false negative
predicate bar() { sum(int x | x = [1, 1, 2] | x) = 3 }
