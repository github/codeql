var cp = require("child_process");

module.exports = function download(path, callback) {
  cp.exec("wget " + path + " | wc -l", callback);
};
