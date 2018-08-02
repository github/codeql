class C {
  static foo() { return 23; }
}

module.exports = C;

// semmle-extractor-options: --abort-on-parse-errors