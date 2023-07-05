var cp = require("child_process"),
    shellQuote = require('shell-quote');

module.exports = function download(path, options, callback) {
  cp.execFile("wget", shellQuote.parse(options).concat(path), callback);
}
