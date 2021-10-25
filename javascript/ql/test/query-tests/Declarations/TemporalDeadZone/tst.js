function f() {
    // NOT OK
    s = null;
    let s = "hi";
    // OK
    s = "hello";
}

function g() {
    // OK
    s = null;
    var s = "hi";
    // OK
    s = "hello";
}

function do_something() {
    // OK
    let foo;
    let foo;
}

function do_something() {
    // OK
    let foo;
    foo = "bar";
    let foo;
}

if (true) { // enter new scope, TDZ starts
    const func = function () {
        console.log(myVar); // OK!
    };

    function otherfunc() {
        console.log(myVar); // also OK
    }

    // Here we are within the TDZ and
    // accessing `myVar` would cause a `ReferenceError`

    let myVar = 3; // TDZ ends
    func(); // called outside TDZ
}
