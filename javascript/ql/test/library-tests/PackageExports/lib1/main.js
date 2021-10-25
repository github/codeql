module.exports = function isExported() {}

module.exports.foo = require("./foo.js")

module.exports.bar = class Bar {
    constructor(a) {} // all are exported
    static staticMethod(b) {}
    instanceMethod(c) {}
}

class Baz {
    constructor() {} // not exported
    static staticMethod() {} // not exported
    instanceMethod() {} // exported
}

module.exports.Baz = new Baz()