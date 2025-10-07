"use foo"; // $ Alert
"use strict";

function bad() {
    "'use strict'"; // $ Alert
    "use strict;"; // $ Alert
    "'use strict';"; // $ Alert
    "'use strict;'"; // $ Alert
    "use-strict"; // $ Alert
    "use_strict"; // $ Alert
    "uses strict"; // $ Alert
    "use struct;" // $ Alert
    "Use Strict"; // $ Alert
    "use bar"; // $ Alert
}

function ignored() {
    var x = 42;
    "use baz"; // OK - not a directive, positionally
}

function good() {
    "use strict";
    "use asm";
    "use babel";
    "use 6to5";
    "format cjs"
    "format esm";
    "format global";
    "format register";
    "ngInject";
    "ngNoInject";
    "deps foo";
    "deps bar";
    "use server";
    "use client";
}

function data() {
    "[0, 0, 0];"; // $ Alert
    "[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];"; // $ Alert
}

function yui() {
    "foo:nomunge";
    "bar:nomunge, baz:nomunge,qux:nomunge";
    ":nomunge"; // $ Alert
    "foo(), bar, baz:nomunge"; // $ Alert
}

function babel_typeof(obj) {
    "@babel/helpers - typeof"
}
