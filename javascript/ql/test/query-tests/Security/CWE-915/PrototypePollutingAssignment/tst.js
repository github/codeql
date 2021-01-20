let express = require('express');
let app = express();

app.get('/', (req, res) => {
    let taint = String(req.query.data);

    let object = {};
    object[taint][taint] = taint; // NOT OK
    object[taint].foo = 'bar'; // NOT OK - may pollute, although attacker has no control over data being injected
    object.baz[taint] = taint; // OK

    mutateObject(object[taint], 'blah');

    unsafeGetProp(object, taint).foo = 'bar'; // NOT OK
    unsafeGetProp(object, 'safe').foo = 'bar'; // OK

    safeGetProp(object, taint).foo = 'bar'; // OK

    let possiblyProto = object[taint] || new Box();
    possiblyProto.m();

    let prototypeLessObject = Object.create(null);
    prototypeLessObject[taint][taint] = taint; // OK

    let directlyMutated = {};
    directlyMutated[taint] = taint; // OK - can't affect Object.prototype

    if (object.hasOwnProperty(taint)) {
        object[taint].foo = 'bar'; // OK
    }
});

function mutateObject(obj, x) {
    obj.foo = x; // NOT OK
    if (obj instanceof Object) {
        obj.foo = x; // OK
    }
    if (obj != null) {
        obj.foo = x; // NOT OK
    }
    if (typeof obj === 'function') {
        obj.foo = x; // OK
    }
    if (typeof obj !== 'function') {
        obj.foo = x; // NOT OK
    }
    if (typeof obj === 'object') {
        obj.foo = x; // NOT OK
    }
    if (typeof obj !== 'object') {
        obj.foo = x; // OK
    }
}

function unsafeGetProp(obj, prop) {
    return obj ? obj[prop] : null;
}

function safeGetProp(obj, prop) {
    if (prop === '__proto__' || prop === 'constructor') {
        return null;
    }
    return obj ? obj[prop] : null;
}

class Box {
    constructor(x) {
        this.x = x;
    }
    m() {
        this.foo = 'bar'; // OK - 'this' won't refer to Object.prototype
    }
}
