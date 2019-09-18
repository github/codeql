function test(bar, e) {
  let foo = bar;
  e.target::foo::baz();
}

// semmle-extractor-options: --experimental