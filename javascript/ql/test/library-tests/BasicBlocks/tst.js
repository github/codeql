function* f(x) {
  x = x || 42;
  g();
  yield x;
  return 23;
}

function g() {}