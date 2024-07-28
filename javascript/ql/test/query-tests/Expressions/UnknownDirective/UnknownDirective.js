"use foo"; // NOT OK
"use strict"; // NOT OK

function bad() {
    "'use strict'"; // NOT OK
    "use strict;"; // NOT OK
    "'use strict';"; // NOT OK
    "'use strict;'"; // NOT OK
    "use-strict"; // NOT OK
    "use_strict"; // NOT OK
    "uses strict"; // NOT OK
    "use struct;" // NOT OK
    "Use Strict"; // NOT OK
    "use bar"; // NOT OK
}

function ignored() {
    var x = 42;
    "use baz"; // OK: not a directive, positionally
}

function good() {
    "use strict"; // OK
    "use asm"; // OK
    "use babel"; // OK
    "use 6to5"; // OK
    "format cjs" // OK
    "format esm"; // OK
    "format global"; // OK
    "format register"; // OK
    "ngInject"; // OK
    "ngNoInject"; // OK
    "deps foo"; // OK
    "deps bar"; // OK
    "use server"; // OK
    "use client"; // OK
}

function data() {
    "[0, 0, 0];"; // NOT OK
    "[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];"; // NOT OK
}

function yui() {
    "foo:nomunge"; // OK
    "bar:nomunge, baz:nomunge,qux:nomunge"; // OK
    ":nomunge"; // NOT OK
    "foo(), bar, baz:nomunge"; // NOT OK
}

function babel_typeof(obj) {
    "@babel/helpers - typeof"
}
