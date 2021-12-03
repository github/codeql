function test() {
  let taint = source();
  
  sink({ ...taint }); // NOT OK
  sink({ f: 'hello', ...taint, g: 'world' }); // NOT OK

  sink([ ...taint ]); // NOT OK
  sink([ 1, 2, ...taint, 3 ]); // NOT OK
}
