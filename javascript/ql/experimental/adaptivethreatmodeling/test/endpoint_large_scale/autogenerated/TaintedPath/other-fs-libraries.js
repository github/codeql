var http = require("http"),
  url = require("url"),
  fs = require("fs"),
  gracefulFs = require("graceful-fs"),
  fsExtra = require("fs-extra"),
  originalFs = require("original-fs");

var server = http.createServer(function(req, res) {
  var path = url.parse(req.url, true).query.path;

  fs.readFileSync(path); // NOT OK
  gracefulFs.readFileSync(path); // NOT OK
  fsExtra.readFileSync(path); // NOT OK
  originalFs.readFileSync(path); // NOT OK

  getFsModule(true).readFileSync(path); // NOT OK
  getFsModule(false).readFileSync(path); // NOT OK

  require("./my-fs-module").require(true).readFileSync(path); // NOT OK

  let flexibleModuleName = require(process.versions["electron"]
    ? "original-fs"
    : "fs");
  flexibleModuleName.readFileSync(path); // NOT OK
});

function getFsModule(special) {
  if (special) {
    return require("fs");
  } else {
    return require("original-fs");
  }
}

var util = require("util");

http.createServer(function(req, res) {
  var path = url.parse(req.url, true).query.path;

  util.promisify(fs.readFileSync)(path); // NOT OK
  require("bluebird").promisify(fs.readFileSync)(path); // NOT OK
  require("bluebird").promisifyAll(fs).readFileSync(path); // NOT OK
});


const asyncFS = require("./my-async-fs-module");

http.createServer(function(req, res) {
  var path = url.parse(req.url, true).query.path;

  fs.readFileSync(path); // NOT OK
  asyncFS.readFileSync(path); // NOT OK
});
