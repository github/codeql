var cp = require("child_process");

module.exports = function download(path, callback) {
  cp.execSync("wget " + path, callback);
}
