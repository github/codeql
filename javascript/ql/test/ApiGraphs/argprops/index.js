const assert = require("assert");

let o = {
    foo: 23 /* def (member foo (parameter 0 (member equal (member exports (module assert))))) */
};
assert.equal(o, o);
