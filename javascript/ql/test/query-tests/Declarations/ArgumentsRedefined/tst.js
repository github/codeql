function f() {
  if (arguments[0].isArray())
    arguments = arguments[0]; // NOT OK
}

function g(x, y) {
  var arguments = [y, x]; // NOT OK
}

(function (){
    for ([arguments] of o);
    for ([arguments = 4] of o);
});
