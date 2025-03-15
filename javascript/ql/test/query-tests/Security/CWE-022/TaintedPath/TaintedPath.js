var fs = require('fs'),
    http = require('http'),
    url = require('url'),
    sanitize = require('sanitize-filename'),
    pathModule = require('path')
    ;

var server = http.createServer(function(req, res) {
  let path = url.parse(req.url, true).query.path; // $ Source

  res.write(fs.readFileSync(path)); // $ Alert - This could read any file on the file system

  res.write(fs.readFileSync("/home/user/" + path)); // $ Alert - This could still read any file on the file system

  if (path.startsWith("/home/user/"))
      res.write(fs.readFileSync(path)); // $ Alert - Insufficient sanitisation

  if (path.indexOf("secret") == -1)
      res.write(fs.readFileSync(path)); // $ Alert - Insufficient sanitisation

  if (fs.existsSync(path))
      res.write(fs.readFileSync(path)); // $ Alert - Insufficient sanitisation

  if (path === 'foo.txt')
    res.write(fs.readFileSync(path)); // OK - Path is compared to white-list

  if (path === 'foo.txt' || path === 'bar.txt')
    res.write(fs.readFileSync(path)); // OK - Path is compared to white-list

  if (path === 'foo.txt' || path === 'bar.txt' || someOpaqueCondition())
    res.write(fs.readFileSync(path)); // $ Alert - Path is incompletely compared to white-list

  path = sanitize(path);
  res.write(fs.readFileSync(path)); // OK - Path is sanitized

  path = url.parse(req.url, true).query.path; // $ Source
  // OK - basename is safe
  res.write(fs.readFileSync(pathModule.basename(path)));
  res.write(fs.readFileSync(pathModule.dirname(path))); // $ Alert - taint is preserved
  // OK - extname is safe
  res.write(fs.readFileSync(pathModule.extname(path)));
  res.write(fs.readFileSync(pathModule.join(path))); // $ Alert - taint is preserved
  res.write(fs.readFileSync(pathModule.join(x, y, path, z))); // $ Alert - taint is preserved
  res.write(fs.readFileSync(pathModule.normalize(path))); // $ Alert - taint is preserved
  res.write(fs.readFileSync(pathModule.relative(x, path))); // $ Alert - taint is preserved
  res.write(fs.readFileSync(pathModule.relative(path, x))); // $ Alert - taint is preserved
  res.write(fs.readFileSync(pathModule.resolve(path))); // $ Alert - taint is preserved
  res.write(fs.readFileSync(pathModule.resolve(x, y, path, z))); // $ Alert - taint is preserved
  res.write(fs.readFileSync(pathModule.toNamespacedPath(path))); // $ Alert - taint is preserved
});

var server = http.createServer(function(req, res) {
    // tests for a few uri-libraries
    res.write(fs.readFileSync(require("querystringify").parse(req.url).query)); // $ Alert
    res.write(fs.readFileSync(require("query-string").parse(req.url).query)); // $ Alert
    res.write(fs.readFileSync(require("querystring").parse(req.url).query)); // $ Alert
});

(function(){

    var express = require('express');
    var application = express();

    var views_local = (req, res) => res.render(req.params[0]); // $ Alert
    application.get('/views/*', views_local);

    var views_imported = require("./views");
    application.get('/views/*', views_imported);

})();

var server = http.createServer(function(req, res) {
	let path = url.parse(req.url, true).query.path; // $ Source

	res.write(fs.readFileSync(fs.realpathSync(path))); // $ Alert
	fs.realpath(path,
	                function(err, realpath){
		                res.write(fs.readFileSync(realpath)); // $ Alert
	                }
	               );

});

var server = http.createServer(function(req, res) {
  let path = url.parse(req.url, true).query.path;

  if (path) { // sanitization
    path = path.replace(/[\]\[*,;'"`<>\\?\/]/g, ''); // remove all invalid characters from states plus slashes
    path = path.replace(/\.\./g, ''); // remove all ".."
  }

  res.write(fs.readFileSync(path));  // OK - Is sanitized above.
});

var server = http.createServer(function(req, res) {
  let path = url.parse(req.url, true).query.path;

  if (!path) {

  } else { // sanitization
	  path = path.replace(/[\]\[*,;'"`<>\\?\/]/g, ''); // remove all invalid characters from states plus slashes
    path = path.replace(/\.\./g, ''); // remove all ".."
  }

  res.write(fs.readFileSync(path));  // OK - Is sanitized above.
});

var server = http.createServer(function(req, res) {
	let path = url.parse(req.url, true).query.path; // $ Source

	require('send')(req, path); // $ Alert
});

var server = http.createServer(function(req, res) {
  let path = url.parse(req.url, true).query.path; // $ Source

  fs.readFileSync(path); // $ Alert

  var split = path.split("/");

  fs.readFileSync(split.join("/")); // $ Alert

  fs.readFileSync(prefix + split[split.length - 1])

  fs.readFileSync(split[x]) // $ Alert
  fs.readFileSync(prefix + split[x]) // $ Alert

  var concatted = prefix.concat(split);
  fs.readFileSync(concatted.join("/")); // $ Alert

  var concatted2 = split.concat(prefix);
  fs.readFileSync(concatted2.join("/")); // $ Alert

  fs.readFileSync(split.pop()); // $ Alert

});

var server = http.createServer(function(req, res) {
  let path = url.parse(req.url, true).query.path; // $ Source

  // Removal of forward-slash or dots.
  res.write(fs.readFileSync(path.replace(/[\]\[*,;'"`<>\\?\/]/g, '')));
  res.write(fs.readFileSync(path.replace(/[abcd]/g, ''))); // $ Alert
  res.write(fs.readFileSync(path.replace(/[./]/g, '')));
  res.write(fs.readFileSync(path.replace(/[foobar/foobar]/g, '')));
  res.write(fs.readFileSync(path.replace(/\//g, '')));
  res.write(fs.readFileSync(path.replace(/\.|\//g, '')));

  res.write(fs.readFileSync(path.replace(/[.]/g, ''))); // $ Alert - can be absolute
  res.write(fs.readFileSync(path.replace(/[..]/g, ''))); // $ Alert - can be absolute
  res.write(fs.readFileSync(path.replace(/\./g, ''))); // $ Alert - can be absolute
  res.write(fs.readFileSync(path.replace(/\.\.|BLA/g, ''))); // $ Alert - can be absolute

  if (!pathModule.isAbsolute(path)) {
    res.write(fs.readFileSync(path.replace(/[.]/g, '')));
  	res.write(fs.readFileSync(path.replace(/[..]/g, '')));
    res.write(fs.readFileSync(path.replace(/\./g, '')));
  	res.write(fs.readFileSync(path.replace(/\.\.|BLA/g, '')));
  }

  // removing of "../" from prefix.
  res.write(fs.readFileSync("prefix" + pathModule.normalize(path).replace(/^(\.\.[\/\\])+/, '')));
  res.write(fs.readFileSync("prefix" + pathModule.normalize(path).replace(/(\.\.[\/\\])+/, '')));
  res.write(fs.readFileSync("prefix" + pathModule.normalize(path).replace(/(\.\.\/)+/, '')));
  res.write(fs.readFileSync("prefix" + pathModule.normalize(path).replace(/(\.\.\/)*/, '')));

  res.write(fs.readFileSync("prefix" + path.replace(/^(\.\.[\/\\])+/, ''))); // $ Alert - not normalized
  res.write(fs.readFileSync(pathModule.normalize(path).replace(/^(\.\.[\/\\])+/, ''))); // $ Alert - can be absolute
});

import normalizeUrl from 'normalize-url';

var server = http.createServer(function(req, res) {
  // tests for a few more uri-libraries
  const qs = require("qs");
  res.write(fs.readFileSync(qs.parse(req.url).foo)); // $ Alert
  res.write(fs.readFileSync(qs.parse(normalizeUrl(req.url)).foo)); // $ Alert
  const parseqs = require("parseqs");
  res.write(fs.readFileSync(parseqs.decode(req.url).foo)); // $ Alert
});

const cp = require("child_process");
var server = http.createServer(function(req, res) {
  let path = url.parse(req.url, true).query.path; // $ Source
  cp.execSync("foobar", {cwd: path}); // $ Alert
  cp.execFileSync("foobar", ["args"], {cwd: path}); // $ Alert
  cp.execFileSync("foobar", {cwd: path}); // $ Alert
});

var server = http.createServer(function(req, res) {
  let path = url.parse(req.url, true).query.path; // $ Source

  // Removal of forward-slash or dots.
  res.write(fs.readFileSync(path.replace(new RegExp("[\\]\\[*,;'\"`<>\\?/]", 'g'), '')));
  res.write(fs.readFileSync(path.replace(new RegExp("[\\]\\[*,;'\"`<>\\?/]", ''), ''))); // $ Alert
  res.write(fs.readFileSync(path.replace(new RegExp("[\\]\\[*,;'\"`<>\\?/]", unknownFlags()), ''))); // OK - Might be okay depending on what unknownFlags evaluates to.
});

var server = http.createServer(function(req, res) {
  let path = url.parse(req.url, true).query.path; // $ Source

  res.write(fs.readFileSync(path.replace(new RegExp("[.]", 'g'), ''))); // $ Alert - can be absolute

  if (!pathModule.isAbsolute(path)) {
    res.write(fs.readFileSync(path.replace(new RegExp("[.]", ''), ''))); // $ Alert
    res.write(fs.readFileSync(path.replace(new RegExp("[.]", 'g'), '')));
    res.write(fs.readFileSync(path.replace(new RegExp("[.]", unknownFlags()), '')));
  }
});
  
var srv = http.createServer(function(req, res) {
  let path = url.parse(req.url, true).query.path; // $ Source
  const improperEscape = escape(path);
  res.write(fs.readFileSync(improperEscape)); // $ Alert
  const improperEscape2 = unescape(path);
  res.write(fs.readFileSync(improperEscape2)); // $ Alert
});
