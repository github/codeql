function f(o) {
  let { x, ...ys } = o;
  return ys;
}

// semmle-extractor-options: --experimental