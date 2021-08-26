function foo1(arg1, arg2) {
  return arg1;
}

function foo2(arg1, arg2) {
  return arg2;
}

function foo1_apply(arr) {
  return foo1.apply(this, arr);
}

function foo1_call(arr) {
  return foo1.call(this, arr[0], arr[1]);
}


var source = "source";

var sink0 = foo1.call(null, source, "");     // OK
var sink1 = foo2.call(null, source, "");     // NOT OK

var sink2 = foo1.apply(null, [source, ""]);  // OK
var sink3 = foo2.apply(null, [source, ""]);  // NOT OK

var sink4 = foo1_apply([source, ""]);  // OK
var sink5 = foo1_apply(["", source]);  // NOT OK

var sink6 = foo1_call([source, ""]);  // OK
var sink7 = foo1_call(["", source]);  // NOT OK
