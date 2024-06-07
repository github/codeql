const impl = require("./lib/impl.js");

module.exports = {
    impl,
    util: require("./lib/utils"),
    other: require("./lib/stuff"),
    util2: require("./lib/utils2"),
    esmodule: require("./lib/esmodule-reexport"),
};
