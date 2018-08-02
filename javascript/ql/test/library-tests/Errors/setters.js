class C {
  set x() {}
  set y(...ys) {}
  set z(z, ...zs) {}
}
var o = {
  set x() {},
  set y(...ys) {},
  set z(z, ...zs) {}
};

// semmle-extractor-options: --tolerate-parse-errors
