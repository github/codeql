import LibThing.Foo

query predicate test(int i) {
  foo(i) and
  bar(i)
}

predicate bar(int i) { i = 4 }
