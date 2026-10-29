const a = require("./a");

module.exports = {
    /** name:reexport.bar */
    bar: function bar() {},
    ...a
}