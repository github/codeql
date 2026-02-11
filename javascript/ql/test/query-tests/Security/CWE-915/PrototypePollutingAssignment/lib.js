module.exports.set = function recSet(obj, path, value) { // $ Source
  var currentPath = path[0];
  var currentValue = obj[currentPath];
  if (path.length === 1) {
    if (currentValue === void 0) {
      obj[currentPath] = value; // $ Alert
    }
    return currentValue;
  }

  return recSet(obj[currentPath], path.slice(1), value);
}

module.exports.set2 = function (obj, path, value) { // $ Source
  obj[path[0]][path[1]] = value; // $ Alert
}

module.exports.setWithArgs = function() {
  var obj = arguments[0];
  var path = arguments[1]; // $ Source
  var value = arguments[2];
  obj[path[0]][path[1]] = value; // $ Alert
}

module.exports.usedInTest = function (obj, path, value) { // $ Source
  return obj[path[0]][path[1]] = value; // $ Alert
}

module.exports.setWithArgs2 = function() {
  const args = Array.prototype.slice.call(arguments); // $ Source
  var obj = args[0];
  var path = args[1];
  var value = args[2];
  obj[path[0]][path[1]] = value; // $ Alert
}

module.exports.setWithArgs3 = function() {
  const args = Array.from(arguments); // $ Source
  var obj = args[0];
  var path = args[1];
  var value = args[2];
  obj[path[0]][path[1]] = value; // $ Alert
}

function id(s) {
  return s;
}

module.exports.id = id;

module.exports.notVulnerable = function () {
  const path = id("x");
  const value = id("y");
  const obj = id("z");
  return (obj[path[0]][path[1]] = value);
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
    return (obj[path[0]][path[1]] = value); // $ MISSING: Alert - lacking local field step
  }

  safe() {
    const obj = this.obj;
    obj[path[0]] = this.value;
  }
}

module.exports.Foo = Foo;

module.exports.delete = function() {
  var obj = arguments[0];
  var path = arguments[1]; // $ Source
  delete obj[path[0]];
  var prop = arguments[2];
  var proto = obj[path[0]];
  delete proto[prop]; // $ Alert
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
  var one = arguments[1]; // $ Source
  var two = arguments[2];
  var value = arguments[3];
  
  obj[one][two] = value; // $ Alert

  if (isPossibilityOfPrototypePollution(one) || isPossibilityOfPrototypePollution(two)) {
    throw new Error('Prototype pollution is not allowed');
  }
  obj[one][two] = value;
}

module.exports.returnsObj = function () {
    return {
        set: function (obj, path, value) { // $ Source
            obj[path[0]][path[1]] = value; // $ Alert
        }
    }
}

class MyClass {
    constructor() {}

    set(obj, path, value) { // $ Source
        obj[path[0]][path[1]] = value; // $ Alert
    }

    static staticSet(obj, path, value) {
        obj[path[0]][path[1]] = value; // OK - not exported
    }
}
module.exports.returnsMewMyClass = function () {
    return new MyClass();
}