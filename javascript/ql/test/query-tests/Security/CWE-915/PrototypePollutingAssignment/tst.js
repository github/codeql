let express = require('express');
let app = express();

app.get('/', (req, res) => {
    let taint = String(req.query.data); // $ Source

    let object = {};
    object[taint][taint] = taint; // $ Alert
    object[taint].foo = 'bar'; // $ Alert - may pollute, although attacker has no control over data being injected
    object.baz[taint] = taint;

    mutateObject(object[taint], 'blah');

    unsafeGetProp(object, taint).foo = 'bar'; // $ Alert
    unsafeGetProp(object, 'safe').foo = 'bar';

    safeGetProp(object, taint).foo = 'bar';

    let possiblyProto = object[taint] || new Box();
    possiblyProto.m();

    let prototypeLessObject = Object.create(null);
    prototypeLessObject[taint][taint] = taint;

    let directlyMutated = {};
    directlyMutated[taint] = taint; // OK - can't affect Object.prototype

    if (object.hasOwnProperty(taint)) {
        object[taint].foo = 'bar';
    }
});

function mutateObject(obj, x) {
    obj.foo = x; // $ Alert
    if (obj instanceof Object) {
        obj.foo = x;
    }
    if (obj != null) {
        obj.foo = x; // $ Alert
    }
    if (typeof obj === 'function') {
        obj.foo = x;
    }
    if (typeof obj !== 'function') {
        obj.foo = x; // $ Alert
    }
    if (typeof obj === 'object') {
        obj.foo = x; // $ Alert
    }
    if (typeof obj !== 'object') {
        obj.foo = x;
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
    let taint = String(req.query.data); // $ Source

    let object = {};
    object[taint][taint] = taint; // $ Alert

    object["" + taint]["" + taint] = taint; // $ Alert

    if (!taint.includes("__proto__")) {
        object[taint][taint] = taint;
    } else {
        object[taint][taint] = taint; // $ Alert
    }
});

app.get('/foo', (req, res) => {
    let obj = {};
    obj[req.query.x.replace('_', '-')].x = 'foo';
    obj[req.query.x.replace('_', '')].x = 'foo'; // $ Alert
    obj[req.query.x.replace(/_/g, '')].x = 'foo';
    obj[req.query.x.replace(/_/g, '-')].x = 'foo';
    obj[req.query.x.replace(/__proto__/g, '')].x = 'foo'; // $ Alert - "__pr__proto__oto__"
    obj[req.query.x.replace('o', '0')].x = 'foo';
});

app.get('/bar', (req, res) => {
    let taint = String(req.query.data); // $ Source

    let object = {};
    object[taint][taint] = taint; // $ Alert

    const bad = ["__proto__", "constructor"];
    if (bad.includes(taint)) {
        return;
    }

    object[taint][taint] = taint;
});

app.get('/assign', (req, res) => {
    let taint = String(req.query.data);
    let plainObj = {};

    let object = Object.assign({}, plainObj[taint]);
    object[taint] = taint; // OK - 'object' is not Object.prototype itself (but possibly a copy)

    let dest = {};
    Object.assign(dest, plainObj[taint]);
    dest[taint] = taint; // OK - 'dest' is not Object.prototype itself (but possibly a copy)
});

app.get('/foo', (req, res) => {
    let obj = {};
    obj[req.query.x.replace(new RegExp('_', 'g'), '')].x = 'foo';
    obj[req.query.x.replace(new RegExp('_', ''), '')].x = 'foo'; // $ Alert
    obj[req.query.x.replace(new RegExp('_', unknownFlags()), '')].x = 'foo';
});
