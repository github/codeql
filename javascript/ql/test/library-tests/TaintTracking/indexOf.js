let whitelist = ['a', 'b', 'c'];

function test() {
  let x = source();
  
  if (whitelist.indexOf(x) < -1) {
    // unreachable
  } else {
    sink(x); // NOT OK
  }

  if (whitelist.indexOf(x) > 1) {
    sink(x) // OK
  }
}
