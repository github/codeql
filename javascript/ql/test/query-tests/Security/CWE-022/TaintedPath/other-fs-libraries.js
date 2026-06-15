var http = require("http"),
  url = require("url"),
  fs = require("fs"),
  gracefulFs = require("graceful-fs"),
  fsExtra = require("fs-extra"),
  originalFs = require("original-fs");

var server = http.createServer(function(req, res) {
  var path = url.parse(req.url, true).query.path; // $ Source

  fs.readFileSync(path); // $ Alert
  gracefulFs.readFileSync(path); // $ Alert
  fsExtra.readFileSync(path); // $ Alert
  originalFs.readFileSync(path); // $ Alert

  getFsModule(true).readFileSync(path); // $ Alert
  getFsModule(false).readFileSync(path); // $ Alert

  require("./my-fs-module").require(true).readFileSync(path); // $ Alert

  let flexibleModuleName = require(process.versions["electron"]
    ? "original-fs"
    : "fs");
  flexibleModuleName.readFileSync(path); // $ Alert
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
  var path = url.parse(req.url, true).query.path; // $ Source

  util.promisify(fs.readFileSync)(path); // $ Alert
  require("bluebird").promisify(fs.readFileSync)(path); // $ Alert
  require("bluebird").promisifyAll(fs).readFileSync(path); // $ Alert
});


const asyncFS = require("./my-async-fs-module");

http.createServer(function(req, res) {
  var path = url.parse(req.url, true).query.path; // $ Source

  fs.readFileSync(path); // $ Alert
  asyncFS.readFileSync(path); // $ Alert

  require("pify")(fs.readFileSync)(path); // $ Alert
  require("pify")(fs).readFileSync(path); // $ Alert

  require('util.promisify')(fs.readFileSync)(path); // $ Alert

  require("thenify")(fs.readFileSync)(path); // $ Alert

  const readPkg = require('read-pkg');
  var pkg = readPkg.readPackageSync({cwd: path}); // $ Alert
  var pkgPromise = readPkg.readPackageAsync({cwd: path}); // $ Alert
});

const mkdirp = require("mkdirp");
http.createServer(function(req, res) {
  var path = url.parse(req.url, true).query.path; // $ Source

  fs.readFileSync(path); // $ Alert
  mkdirp(path); // $ Alert
  mkdirp.sync(path); // $ Alert
  func(path);
});
function func(x) {
  fs.readFileSync(x); // $ Alert
}

const fsp = require("fs/promises");
http.createServer(function(req, res) {
  var path = url.parse(req.url, true).query.path; // $ Source

  fsp.readFile(path); // $ Alert
});
