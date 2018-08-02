function f({ x, ...ys }) {
  return ys;
}

// semmle-extractor-options: --experimental