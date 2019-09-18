function outer() {
  function inner() {
    yield 1;
  }
  inner().next()
}

// semmle-extractor-options: --experimental
