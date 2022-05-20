function f(x) {
  var y, z;
  if (x)
    y = x;
  z = y;
  while (x)
    z++;
}


function g(x) {
  function h() { // no SSA definition, since `h` is dead
    return x;
  }
  x = 42;
}

function k() {
  var x = 0;
  function* iter() {
    console.log(x);
    yield;
    console.log(x);
  }
  var gen = iter();
  gen.next();
  ++x;
  gen.next();
}

function l() {
  function inner() {
    // capture both `x` and `y`
    x += y;
  }
  var x = 0, y = 1;
  inner();  // induces capture of `x`, but not of `y`
  return x + y;
}

function *m() {
  var x = 0, y = 1;
  var inc = () => /* capture x */ ++x;
  yield inc; // induces capture of `x`, but not of `y`
  return x + y;
}
