var cp = require("child_process");

module.exports = function download(path, callback) {
  cp.execFileSync("wget", [path], callback);
}
