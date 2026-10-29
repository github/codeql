function f() {
    s = null; // $ Alert
    let s = "hi";

    s = "hello";
}

function g() {

    s = null;
    var s = "hi";

    s = "hello";
}

function do_something() {

    let foo;
    let foo;
}

function do_something() {

    let foo;
    foo = "bar";
    let foo;
}

if (true) { // enter new scope, TDZ starts
    const func = function () {
        console.log(myVar);
    };

    function otherfunc() {
        console.log(myVar); // also OK
    }

    // Here we are within the TDZ and
    // accessing `myVar` would cause a `ReferenceError`

    let myVar = 3; // TDZ ends
    func(); // called outside TDZ
}
