var fs = require("fs");

module.exports = {
    foo: function (x) {
        return fs.readFileSync(x);
    }
}