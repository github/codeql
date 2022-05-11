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


app.get('/', (req, res) => {
    let taint = String(req.query.data);

    let object = {};
    object[taint][taint] = taint; // NOT OK

    object["" + taint]["" + taint] = taint; // NOT OK

    if (!taint.includes("__proto__")) {
        object[taint][taint] = taint; // OK
    } else {
        object[taint][taint] = taint; // NOT OK
    }
});

app.get('/foo', (req, res) => {
    let obj = {};
    obj[req.query.x.replace('_', '-')].x = 'foo'; // OK
    obj[req.query.x.replace('_', '')].x = 'foo'; // NOT OK
    obj[req.query.x.replace(/_/g, '')].x = 'foo'; // OK
    obj[req.query.x.replace(/_/g, '-')].x = 'foo'; // OK
    obj[req.query.x.replace(/__proto__/g, '')].x = 'foo'; // NOT OK - "__pr__proto__oto__"
    obj[req.query.x.replace('o', '0')].x = 'foo'; // OK
});
