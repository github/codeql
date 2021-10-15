function append() {
  let x = "one";
  x += "two";
  x += "three"
  x += "four"
  return x;
}

function appendClosure(ys) {
  let x = "first";
  ys.forEach(y => {
    x += "one" + y + "two";
  });
  x += "last";
  return x;
}
 
function appendMixed() {
  let x = "one" + "two";
  x += ("three" + "four");
  return x + "five";
}

function joinArrayLiteral() {
  return ["one", "two", "three"].join("");
}

function joinArrayCall() {
  return Array("one", "two", "three").join("");
}

function joinArrayNewCall() {
  return new Array("one", "two", "three").join("");
}

function push() {
  let xs = ["one"];
  xs.push("two");
  xs.push("three", "four");
  return xs.join("");
}

function pushClosure(ys) {
  let xs = ["first"];
  ys.forEach(y => {
    xs.push("one", y, "two");
  });
  xs.push("last");
  return xs.join("");
}

function template(x) {
  return `one ${x} two ${x} three`;
}

function taggedTemplate(mid) {
  return someTag`first ${mid} last`;
}

function templateRepeated(x) {
  return `first ${x}${x}${x} last`;
}

function makeArray() {
  return [];
}

function pushNoLocalCreation() {
  let array = makeArray();
  array.push("one");
  array.push("two");
  array.push("three");
  return array.join("");
}

function joinInClosure() {
  let array = ["one", "two", "three"];
  function f() {
    return array.join();
  }
  return f();
}

function addExprPhi(b) {
  let x = 'one';
  if (b) {
    x += 'two';
  }
  x += 'three';
  return x;
}

function concatCall() {
  let x = 'one';
  x = x.concat('two', 'three');
  return x;
}

function arrayConcat(a, b) {
  return [].concat(a, b);
}

function stringValue() {
  var a = "foo" + "bar" + value;
  var b = value + "foo" + "bar";
  var c = "foo" + ("bar" + "baz")
}