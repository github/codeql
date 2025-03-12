var o = { x: 1, y: 2, z: 3 };

// OK - toplevel for-in
for (var p in o);

function f() {
    // OK - local variable
    for (var p in o);
}

function g() {
    var q = [], i = 0; // property
    for (q[i++] in o); // $ Alert
}

function h() {
    for (p in o); // $ Alert - global
}

function k() {
    for (var p in o); // $ Alert - captured
    return function() {
        return p;
    };
}

function l() {
    var p;
    function m() {
        for (p in o); // $ Alert - captured
    }
}

function m() {
    for (p of o); // $ Alert - global
}

// OK - toplevel
for (p of o);