function test() {
  let x = (function() {
    if (g) return 5;
  })();
  if (x + 1 < 5) {} // OK
}
