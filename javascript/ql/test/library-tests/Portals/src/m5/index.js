const fs = require("fs"),
    base64 = require("base-64/base64.js");

module.exports.readBase64 = function (f) {
    return base64.encode(String(fs.readFileSync(f)));
};
