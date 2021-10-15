var o = { x: 1, y: 2, z: 3 };

// OK: toplevel for-in
for (var p in o);

function f() {
    // OK: local variable
    for (var p in o);
}

function g() {
    // NOT OK: property
    var q = [], i = 0;
    for (q[i++] in o);
}

function h() {
    // NOT OK: global
    for (p in o);
}

function k() {
    // NOT OK: captured
    for (var p in o);
    return function() {
        return p;
    };
}

function l() {
    var p;
    function m() {
        // NOT OK: captured
        for (p in o);
    }
}

function m() {
    // NOT OK: global
    for (p of o);
}

// OK: toplevel
for (p of o);