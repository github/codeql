function f(x) {
  console.log(x);
}

console.log(x); // $ Alert
var x = 1;

function g() {
  console.log(y); // OK - not in same function
}
var y = 1;
