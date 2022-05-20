function f(x) {
  console.log(x); // OK
}

console.log(x); // NOT OK
var x = 1;

function g() {
  console.log(y); // OK (not in same function)
}
var y = 1;
