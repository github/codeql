import * as foolib from 'foolib';

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

function foo1_apply_sink(arr) {
  foo1_sink.apply(this, arr);
}

function foo1_sink(arg1, arg2) {
  sink(arg1); // NOT OK
}

var source = source();

sink(foo1.call(null, source, "")); // NOT OK
sink(foo2.call(null, source, "")); // OK

sink(foo1.apply(null, [source, ""])); // NOT OK
sink(foo2.apply(null, [source, ""])); // OK
sink(foo1_apply([source, ""])); // NOT OK

foo1_apply_sink([source, ""]); // This works, because we don't need a return after a call (the sink is inside the called function).

sink(foo1_apply.apply(["", source])); // OK

sink(foo1_call([source, ""])); // NOT OK
sink(foo1_call(["", source])); // OK


var obj = {
  foo: source(),
  bar: "safe"
};

function foo(x) {
  return bar(x);
}
function bar(x) {
  return x.foo;
}
sink(foo(obj)); // NOT OK

function argumentsObject() {
  function sinkArguments1() {
    sink(arguments[1]); // OK
  }
  function sinkArguments0() {
    sink(arguments[0]); // NOT OK
  }

  function fowardArguments() {
    sinkArguments1.apply(this, arguments);
    sinkArguments0.apply(this, arguments);
  }

  fowardArguments.apply(this, [source, ""]);
}

function sinksThis() {
  sinksThis2.apply(this, arguments);
}

function sinksThis2() {
  sink(this); // NOT OK
}

sinksThis.apply(source(), []);
