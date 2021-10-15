function test1(b) {
  let x = 'one';
  if (b) {
    x += source();
  }
  x += 'three';
  sink(x); // NOT OK
}

function test2(x, foo) {
  let taint = source();
  let value = '';

  sink(value); // OK

  if (x) {
    value += taint;
  }
  value += foo;

  sink(value); // NOT OK
}
