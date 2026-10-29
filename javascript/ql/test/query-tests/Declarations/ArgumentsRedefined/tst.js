function f() {
  if (arguments[0].isArray())
    arguments = arguments[0]; // $ Alert
}

function g(x, y) {
  var arguments = [y, x]; // $ Alert
}

(function (){
    for ([arguments] of o); // $ Alert
    for ([arguments = 4] of o); // $ Alert
});
