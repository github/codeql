var fs = require('fs'),
    http = require('http'),
    url = require('url'),
    sanitize = require('sanitize-filename'),
    pathModule = require('path')
    ;

var server = http.createServer(function(req, res) {
  let path = url.parse(req.url, true).query.path;

  // BAD: This could read any file on the file system
  res.write(fs.readFileSync(path));

  // BAD: This could still read any file on the file system
  res.write(fs.readFileSync("/home/user/" + path));

  if (path.startsWith("/home/user/"))
      res.write(fs.readFileSync(path)); // BAD: Insufficient sanitisation

  if (path.indexOf("secret") == -1)
      res.write(fs.readFileSync(path)); // BAD: Insufficient sanitisation

  if (fs.existsSync(path))
      res.write(fs.readFileSync(path)); // BAD: Insufficient sanitisation

  if (path === 'foo.txt')
    res.write(fs.readFileSync(path)); // GOOD: Path is compared to white-list

  if (path === 'foo.txt' || path === 'bar.txt')
    res.write(fs.readFileSync(path)); // GOOD: Path is compared to white-list

  if (path === 'foo.txt' || path === 'bar.txt' || someOpaqueCondition())
    res.write(fs.readFileSync(path)); // BAD: Path is incompletely compared to white-list

  path = sanitize(path);
  res.write(fs.readFileSync(path)); // GOOD: Path is sanitized

  path = url.parse(req.url, true).query.path;
  // GOOD: basename is safe
  res.write(fs.readFileSync(pathModule.basename(path)));
  // BAD: taint is preserved
  res.write(fs.readFileSync(pathModule.dirname(path)));
  // GOOD: extname is safe
  res.write(fs.readFileSync(pathModule.extname(path)));
  // BAD: taint is preserved
  res.write(fs.readFileSync(pathModule.join(path)));
  // BAD: taint is preserved
  res.write(fs.readFileSync(pathModule.join(x, y, path, z)));
  // BAD: taint is preserved
  res.write(fs.readFileSync(pathModule.normalize(path)));
  // BAD: taint is preserved
  res.write(fs.readFileSync(pathModule.relative(x, path)));
  // BAD: taint is preserved
  res.write(fs.readFileSync(pathModule.relative(path, x)));
  // BAD: taint is preserved
  res.write(fs.readFileSync(pathModule.resolve(path)));
  // BAD: taint is preserved
  res.write(fs.readFileSync(pathModule.resolve(x, y, path, z)));
  // BAD: taint is preserved
  res.write(fs.readFileSync(pathModule.toNamespacedPath(path)));
});

angular.module('myApp', [])
    .directive('myCustomer', function() {
        return {
            templateUrl: "SAFE" // OK
        }
    })
    .directive('myCustomer', function() {
        return {
            templateUrl: Cookie.get("unsafe") // NOT OK
        }
    })

var server = http.createServer(function(req, res) {
    // tests for a few uri-libraries
    res.write(fs.readFileSync(require("querystringify").parse(req.url).query)); // NOT OK
    res.write(fs.readFileSync(require("query-string").parse(req.url).query)); // NOT OK
    res.write(fs.readFileSync(require("querystring").parse(req.url).query)); // NOT OK
});

(function(){

    var express = require('express');
    var application = express();

    var views_local = (req, res) => res.render(req.params[0]);
    application.get('/views/*', views_local);

    var views_imported = require("./views");
    application.get('/views/*', views_imported);

})();

addEventListener('message', (ev) => {
  Cookie.set("unsafe", ev.data);
});

var server = http.createServer(function(req, res) {
	let path = url.parse(req.url, true).query.path;

	res.write(fs.readFileSync(fs.realpathSync(path)));
	fs.realpath(path,
	                function(err, realpath){
		                res.write(fs.readFileSync(realpath));
	                }
	               );

});

var server = http.createServer(function(req, res) {
  let path = url.parse(req.url, true).query.path;
  
  if (path) { // sanitization
    path = path.replace(/[\]\[*,;'"`<>\\?\/]/g, ''); // remove all invalid characters from states plus slashes
    path = path.replace(/\.\./g, ''); // remove all ".."
  }
  
  res.write(fs.readFileSync(path));  // OK. Is sanitized above.
});

var server = http.createServer(function(req, res) {
  let path = url.parse(req.url, true).query.path;
  
  if (!path) {
    
  } else { // sanitization
	  path = path.replace(/[\]\[*,;'"`<>\\?\/]/g, ''); // remove all invalid characters from states plus slashes
    path = path.replace(/\.\./g, ''); // remove all ".."
  }
  
  res.write(fs.readFileSync(path));  // OK. Is sanitized above.
});

var server = http.createServer(function(req, res) {
	let path = url.parse(req.url, true).query.path;

	require('send')(req, path); // NOT OK
});

var server = http.createServer(function(req, res) {
  let path = url.parse(req.url, true).query.path;

  fs.readFileSync(path); // NOT OK
  
  var split = path.split("/");
  
  fs.readFileSync(split.join("/")); // NOT OK

  fs.readFileSync(prefix + split[split.length - 1]) // OK

  fs.readFileSync(split[x]) // NOT OK
  fs.readFileSync(prefix + split[x]) // NOT OK 

  var concatted = prefix.concat(split);
  fs.readFileSync(concatted.join("/")); // NOT OK

  var concatted2 = split.concat(prefix);
  fs.readFileSync(concatted2.join("/")); // NOT OK

  fs.readFileSync(split.pop()); // NOT OK 

});

var server = http.createServer(function(req, res) {
  let path = url.parse(req.url, true).query.path;
  
  // Removal of forward-slash or dots.
  res.write(fs.readFileSync(path.replace(/[\]\[*,;'"`<>\\?\/]/g, ''))); // OK.
  res.write(fs.readFileSync(path.replace(/[abcd]/g, ''))); // NOT OK
  res.write(fs.readFileSync(path.replace(/[./]/g, ''))); // OK
  res.write(fs.readFileSync(path.replace(/[foobar/foobar]/g, ''))); // OK
  res.write(fs.readFileSync(path.replace(/\//g, ''))); // OK
  res.write(fs.readFileSync(path.replace(/\.|\//g, ''))); // OK

  res.write(fs.readFileSync(path.replace(/[.]/g, ''))); // NOT OK (can be absolute)
  res.write(fs.readFileSync(path.replace(/[..]/g, ''))); // NOT OK (can be absolute)
  res.write(fs.readFileSync(path.replace(/\./g, ''))); // NOT OK (can be absolute)
  res.write(fs.readFileSync(path.replace(/\.\.|BLA/g, ''))); // NOT OK (can be absolute)

  if (!pathModule.isAbsolute(path)) {
    res.write(fs.readFileSync(path.replace(/[.]/g, ''))); // OK
  	res.write(fs.readFileSync(path.replace(/[..]/g, ''))); // OK
    res.write(fs.readFileSync(path.replace(/\./g, ''))); // OK
  	res.write(fs.readFileSync(path.replace(/\.\.|BLA/g, ''))); // OK
  }

  // removing of "../" from prefix.
  res.write(fs.readFileSync("prefix" + pathModule.normalize(path).replace(/^(\.\.[\/\\])+/, ''))); // OK
  res.write(fs.readFileSync("prefix" + pathModule.normalize(path).replace(/(\.\.[\/\\])+/, ''))); // OK
  res.write(fs.readFileSync("prefix" + pathModule.normalize(path).replace(/(\.\.\/)+/, ''))); // OK
  res.write(fs.readFileSync("prefix" + pathModule.normalize(path).replace(/(\.\.\/)*/, ''))); // OK

  res.write(fs.readFileSync("prefix" + path.replace(/^(\.\.[\/\\])+/, ''))); // NOT OK - not normalized
  res.write(fs.readFileSync(pathModule.normalize(path).replace(/^(\.\.[\/\\])+/, ''))); // NOT OK (can be absolute)
});