function test() {
  let x = source();

  sink(x); // NOT OK

  if (x === 'a')
    sink(x); // OK

  if (x === 'a' || x === 'b')
    sink(x); // OK

  if (x === 'a' || 1 === 1)
    sink(x); // NOT OK

  if (isSafe(x))
    sink(x); // OK

  if (isSafe(x, y) || isSafe(x, z))
    sink(x); // OK [INCONSISTENCY]

  if (isSafe(x) || 1 === 1)
    sink(x); // NOT OK
}
