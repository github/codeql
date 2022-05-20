module.exports.set = function recSet(obj, path, value) {
  var currentPath = path[0];
  var currentValue = obj[currentPath];
  if (path.length === 1) {
    if (currentValue === void 0) {
      obj[currentPath] = value; // NOT OK
    }
    return currentValue;
  }

  return recSet(obj[currentPath], path.slice(1), value);
}

module.exports.set2 = function (obj, path, value) {
  obj[path[0]][path[1]] = value; // NOT OK
}

module.exports.setWithArgs = function() {
  var obj = arguments[0];
  var path = arguments[1];
  var value = arguments[2];
  obj[path[0]][path[1]] = value; // NOT OK
}

module.exports.usedInTest = function (obj, path, value) {
  return obj[path[0]][path[1]] = value; // NOT OK
}

module.exports.setWithArgs2 = function() {
  const args = Array.prototype.slice.call(arguments);
  var obj = args[0];
  var path = args[1];
  var value = args[2];
  obj[path[0]][path[1]] = value; // NOT OK
}

module.exports.setWithArgs3 = function() {
  const args = Array.from(arguments);
  var obj = args[0];
  var path = args[1];
  var value = args[2];
  obj[path[0]][path[1]] = value; // NOT OK
}

function id(s) {
  return s;
}

module.exports.id = id;

module.exports.notVulnerable = function () {
  const path = id("x");
  const value = id("y");
  const obj = id("z");
  return (obj[path[0]][path[1]] = value); // OK
}

class Foo {
  constructor(o, s, v) {
    this.obj = o;
    this.path = s;
    this.value = v;
  }

  doXss() {
    // not called here, but still bad.
    const obj = this.obj;
    const path = this.path;
    const value = this.value;
    return (obj[path[0]][path[1]] = value); // NOT OK
  }

  safe() {
    const obj = this.obj;
    obj[path[0]] = this.value; // OK
  }
}

module.exports.Foo = Foo;

module.exports.delete = function() {
  var obj = arguments[0];
  var path = arguments[1];
  delete obj[path[0]]; // OK
  var prop = arguments[2];
  var proto = obj[path[0]];
  delete proto[prop]; // NOT OK
}

module.exports.fixedProp = function (obj, path, value) {
  var maybeProto = obj[path];
  maybeProto.foo = value; // OK - fixed properties from library inputs are OK.

  var i = 0;
  maybeProto[i + 2] = value; // OK - number properties are OK.
}

function isPossibilityOfPrototypePollution(key) {
  return (key === '__proto__' || key === 'constructor');
}

module.exports.sanWithFcuntion = function() {
  var obj = arguments[0];
  var one = arguments[1];
  var two = arguments[2];
  var value = arguments[3];
  
  obj[one][two] = value; // NOT OK

  if (isPossibilityOfPrototypePollution(one) || isPossibilityOfPrototypePollution(two)) {
    throw new Error('Prototype pollution is not allowed');
  }
  obj[one][two] = value; // OK
}
