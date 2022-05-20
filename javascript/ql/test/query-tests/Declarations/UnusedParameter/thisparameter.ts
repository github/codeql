function foo(this: void, x: number) { // OK: 'this' is not an ordinary parameter
  return x;
}
