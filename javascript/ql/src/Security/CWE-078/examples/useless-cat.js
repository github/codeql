var child_process = require('child_process');

module.exports = function (name) {
    return child_process.execSync("cat " + name).toString();
};
