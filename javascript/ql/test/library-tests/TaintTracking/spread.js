import 'dummy';

function test() {
  let taint = source();

  sink({ ...taint }); // NOT OK
  sink({ f: 'hello', ...taint, g: 'world' }); // NOT OK

  sink([ ...taint ]); // NOT OK
  sink([ 1, 2, ...taint, 3 ]); // NOT OK

  fn1(...['x', taint, 'z']);
  fn2.apply(undefined, ['x', taint, 'z']);
}

function fn1(x, y, z) {
  sink(x);
  sink(y); // NOT OK
  sink(z);
}

function fn2(x, y, z) {
  sink(x);
  sink(y); // NOT OK
  sink(z);
}
