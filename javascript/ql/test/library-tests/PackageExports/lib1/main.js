module.exports = function isExported() {}

module.exports.foo = require("./foo.js")

module.exports.bar = class Bar {
    constructor() {} // all are exported
    static staticMethod() {}
    instanceMethod() {}
}

class Baz {
    constructor() {} // not exported
    static staticMethod() {} // not exported
    instanceMethod() {} // exported
}

module.exports.Baz = new Baz()