export function unsafeDeserialize(data) {
  return eval("(" + data + ")"); // NOT OK
}

export function unsafeGetter(obj, name) {
    return eval("obj." + name); // NOT OK
}

export function safeAssignment(obj, value) {
    eval("obj.foo = " + JSON.stringify(value)); // OK
}

global.unsafeDeserialize = function (data) {
  return eval("(" + data + ")"); // NOT OK
}