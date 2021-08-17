function foo1(arg1, arg2) {
  return arg1;
}

function foo2(arg1, arg2) {
  return arg2;
}

function foo11(arr) {
  return foo1.apply(this, arr);
}

var source = "source";

var sink0 = foo1.call(null, source, "");     // OK
var sink1 = foo2.call(null, source, "");     // NOT OK

var sink2 = foo1.apply(null, [source, ""]);  // OK
var sink3 = foo2.apply(null, [source, ""]);  // NOT OK

var sink4 = foo11([source, ""]);  // OK
var sink5 = foo11(["", source]);  // NOT OK
