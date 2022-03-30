var fs = require('fs');

module.exports = function (name) {
    return fs.readFileSync(name).toString();
};
