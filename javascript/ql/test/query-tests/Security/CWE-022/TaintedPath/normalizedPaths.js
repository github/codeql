var fs = require('fs'),
    express = require('express'),
    url = require('url'),
    sanitize = require('sanitize-filename'),
    pathModule = require('path')
    ;

let app = express();

app.get('/basic', (req, res) => {
  let path = req.query.path; // $ Source

  fs.readFileSync(path); // $ Alert
  fs.readFileSync('./' + path); // $ Alert
  fs.readFileSync(path + '/index.html'); // $ Alert
  fs.readFileSync(pathModule.join(path, 'index.html')); // $ Alert
  fs.readFileSync(pathModule.join('/home/user/www', path)); // $ Alert
});

app.get('/normalize', (req, res) => {
  let path = pathModule.normalize(req.query.path); // $ Source

  fs.readFileSync(path); // $ Alert
  fs.readFileSync('./' + path); // $ Alert
  fs.readFileSync(path + '/index.html'); // $ Alert
  fs.readFileSync(pathModule.join(path, 'index.html')); // $ Alert
  fs.readFileSync(pathModule.join('/home/user/www', path)); // $ Alert
});

app.get('/normalize-notAbsolute', (req, res) => {
  let path = pathModule.normalize(req.query.path); // $ Source

  if (pathModule.isAbsolute(path))
    return;

  fs.readFileSync(path); // $ Alert

  if (!path.startsWith("."))
    fs.readFileSync(path);
  else
    fs.readFileSync(path); // $ Alert - wrong polarity

  if (!path.startsWith(".."))
    fs.readFileSync(path);

  if (!path.startsWith("../"))
    fs.readFileSync(path);

  if (!path.startsWith(".." + pathModule.sep))
    fs.readFileSync(path);
});

app.get('/normalize-noInitialDotDot', (req, res) => {
  let path = pathModule.normalize(req.query.path); // $ Source

  if (path.startsWith(".."))
    return;

  fs.readFileSync(path); // $ Alert - could be absolute

  fs.readFileSync("./" + path); // OK - coerced to relative

  fs.readFileSync(path + "/index.html"); // $ Alert - not coerced

  if (!pathModule.isAbsolute(path))
    fs.readFileSync(path);
  else
    fs.readFileSync(path); // $ Alert
});

app.get('/prepend-normalize', (req, res) => {
  // Coerce to relative prior to normalization
  let path = pathModule.normalize('./' + req.query.path); // $ Source

  if (!path.startsWith(".."))
    fs.readFileSync(path);
  else
     fs.readFileSync(path); // $ Alert
});

app.get('/absolute', (req, res) => {
  let path = req.query.path; // $ Source

  if (!pathModule.isAbsolute(path))
    return;

  res.write(fs.readFileSync(path)); // $ Alert

  if (path.startsWith('/home/user/www'))
    res.write(fs.readFileSync(path)); // $ Alert - can still contain '../'
});

app.get('/normalized-absolute', (req, res) => {
  let path = pathModule.normalize(req.query.path); // $ Source

  if (!pathModule.isAbsolute(path))
    return;

  res.write(fs.readFileSync(path)); // $ Alert

  if (path.startsWith('/home/user/www'))
    res.write(fs.readFileSync(path));
});

app.get('/combined-check', (req, res) => {
  let path = pathModule.normalize(req.query.path);

  // Combined absoluteness and folder check in one startsWith call
  if (path.startsWith("/home/user/www"))
    fs.readFileSync(path);

  if (path[0] !== "/" && path[0] !== ".")
    fs.readFileSync(path);
});

app.get('/realpath', (req, res) => {
  let path = fs.realpathSync(req.query.path); // $ Source

  fs.readFileSync(path); // $ Alert
  fs.readFileSync(pathModule.join(path, 'index.html')); // $ Alert

  if (path.startsWith("/home/user/www"))
    fs.readFileSync(path); // OK - both absolute and normalized before check

  fs.readFileSync(pathModule.join('.', path)); // OK - normalized and coerced to relative
  fs.readFileSync(pathModule.join('/home/user/www', path));
});

app.get('/coerce-relative', (req, res) => {
  let path = pathModule.join('.', req.query.path); // $ Source

  if (!path.startsWith('..'))
    fs.readFileSync(path);
  else
    fs.readFileSync(path); // $ Alert
});

app.get('/coerce-absolute', (req, res) => {
  let path = pathModule.join('/home/user/www', req.query.path); // $ Source

  if (path.startsWith('/home/user/www'))
    fs.readFileSync(path);
  else
    fs.readFileSync(path); // $ Alert
});

app.get('/concat-after-normalization', (req, res) => {
  let path = 'foo/' + pathModule.normalize(req.query.path); // $ Source

  if (!path.startsWith('..'))
    fs.readFileSync(path); // $ Alert - prefixing foo/ invalidates check
  else
    fs.readFileSync(path); // $ Alert

  if (!path.includes('..'))
    fs.readFileSync(path);
});

app.get('/noDotDot', (req, res) => {
  let path = pathModule.normalize(req.query.path); // $ Source

  if (path.includes('..'))
    return;

  fs.readFileSync(path); // $ Alert - can still be absolute

  if (!pathModule.isAbsolute(path))
    fs.readFileSync(path);
  else
    fs.readFileSync(path); // $ Alert
});

app.get('/join-regression', (req, res) => {
  let path = req.query.path; // $ Source

  // Regression test for a specific corner case:
  // Some guard nodes sanitize both branches, but for a different set of flow labels.
  // Verify that this does not break anything.
  if (pathModule.isAbsolute(path)) {path;} else {path;}
  if (path.startsWith('/')) {path;} else {path;}
  if (path.startsWith('/x')) {path;} else {path;}
  if (path.startsWith('.')) {path;} else {path;}

  fs.readFileSync(path); // $ Alert

  if (pathModule.isAbsolute(path))
    fs.readFileSync(path); // $ Alert
  else
    fs.readFileSync(path); // $ Alert

  if (path.includes('..'))
    fs.readFileSync(path); // $ Alert
  else
    fs.readFileSync(path); // $ Alert

  if (!path.includes('..') && !pathModule.isAbsolute(path))
    fs.readFileSync(path);
  else
    fs.readFileSync(path); // $ Alert

  let normalizedPath = pathModule.normalize(path);
  if (normalizedPath.startsWith('/home/user/www'))
    fs.readFileSync(normalizedPath);
  else
    fs.readFileSync(normalizedPath); // $ Alert

  if (normalizedPath.startsWith('/home/user/www') || normalizedPath.startsWith('/home/user/public'))
    fs.readFileSync(normalizedPath); // $ SPURIOUS: Alert
  else
    fs.readFileSync(normalizedPath); // $ Alert
});

app.get('/decode-after-normalization', (req, res) => {
  let path = pathModule.normalize(req.query.path); // $ Source

  if (!pathModule.isAbsolute(path) && !path.startsWith('..'))
    fs.readFileSync(path);

  path = decodeURIComponent(path);

  if (!pathModule.isAbsolute(path) && !path.startsWith('..'))
    fs.readFileSync(path); // $ Alert - not normalized
});

app.get('/replace', (req, res) => {
  let path = pathModule.normalize(req.query.path).replace(/%20/g, ' '); // $ Source
  if (!pathModule.isAbsolute(path)) {
    fs.readFileSync(path); // $ Alert

    path = path.replace(/\.\./g, '');
    fs.readFileSync(path);
  }
});

app.get('/resolve-path', (req, res) => {
  let path = pathModule.resolve(req.query.path); // $ Source

  fs.readFileSync(path); // $ Alert

  var self = something();

  if (path.substring(0, self.dir.length) === self.dir)
    fs.readFileSync(path);
  else
    fs.readFileSync(path); // $ Alert - wrong polarity

  if (path.slice(0, self.dir.length) === self.dir)
    fs.readFileSync(path);
  else
    fs.readFileSync(path); // $ Alert - wrong polarity
});

app.get('/relative-startswith', (req, res) => {
  let path = pathModule.resolve(req.query.path); // $ Source

  fs.readFileSync(path); // $ Alert

  var self = something();

  var relative = pathModule.relative(self.webroot, path);
  if(relative.startsWith(".." + pathModule.sep) || relative == "..") {
    fs.readFileSync(path); // $ Alert
  } else {
    fs.readFileSync(path);
  }

  let newpath = pathModule.normalize(path);
  var relativePath = pathModule.relative(pathModule.normalize(workspaceDir), newpath);
  if (relativePath.indexOf('..' + pathModule.sep) === 0) {
    fs.readFileSync(newpath); // $ Alert
  } else {
    fs.readFileSync(newpath);
  }

  let newpath = pathModule.normalize(path);
  var relativePath = pathModule.relative(pathModule.normalize(workspaceDir), newpath);
  if (relativePath.indexOf('../') === 0) {
    fs.readFileSync(newpath); // $ Alert
  } else {
    fs.readFileSync(newpath);
  }

  let newpath = pathModule.normalize(path);
  var relativePath = pathModule.relative(pathModule.normalize(workspaceDir), newpath);
  if (pathModule.normalize(relativePath).indexOf('../') === 0) {
    fs.readFileSync(newpath); // $ Alert
  } else {
    fs.readFileSync(newpath);
  }

  let newpath = pathModule.normalize(path);
  var relativePath = pathModule.relative(pathModule.normalize(workspaceDir), newpath);
  if (pathModule.normalize(relativePath).indexOf('../')) {
    fs.readFileSync(newpath);
  } else {
    fs.readFileSync(newpath); // $ Alert
  }
});

var isPathInside = require("is-path-inside"),
    pathIsInside = require("path-is-inside");
app.get('/pseudo-normalizations', (req, res) => {
	let path = req.query.path; // $ Source
	fs.readFileSync(path); // $ Alert
	if (isPathInside(path, SAFE)) {
		fs.readFileSync(path);
		return;
	} else {
		fs.readFileSync(path); // $ Alert

	}
	if (pathIsInside(path, SAFE)) {
		fs.readFileSync(path); // $ Alert - can be of the form 'safe/directory/../../../etc/passwd'
		return;
	} else {
		fs.readFileSync(path); // $ Alert

	}

	let normalizedPath = pathModule.join(SAFE, path);
	if (pathIsInside(normalizedPath, SAFE)) {
		fs.readFileSync(normalizedPath);
		return;
	} else {
		fs.readFileSync(normalizedPath); // $ Alert
	}

	if (pathIsInside(normalizedPath, SAFE)) {
		fs.readFileSync(normalizedPath);
		return;
	} else {
		fs.readFileSync(normalizedPath); // $ Alert

	}

});

app.get('/yet-another-prefix', (req, res) => {
	let path = pathModule.resolve(req.query.path); // $ Source

	fs.readFileSync(path); // $ Alert

	var abs = pathModule.resolve(path);

	if (abs.indexOf(root) !== 0) {
		fs.readFileSync(path); // $ Alert
		return;
    }
	fs.readFileSync(path);
});

var rootPath = process.cwd();
app.get('/yet-another-prefix2', (req, res) => {
  let path = req.query.path; // $ Source

  fs.readFileSync(path); // $ Alert

  var requestPath = pathModule.join(rootPath, path);

  var targetPath;
  if (!allowPath(requestPath, rootPath)) {
    targetPath = rootPath;
    fs.readFileSync(requestPath); // $ Alert
  } else {
    targetPath = requestPath;
    fs.readFileSync(requestPath);
  }
  fs.readFileSync(targetPath);

  function allowPath(requestPath, rootPath) {
    return requestPath.indexOf(rootPath) === 0;
  }
});

import slash from 'slash';
app.get('/slash-stuff', (req, res) => {
  let path = req.query.path; // $ Source

  fs.readFileSync(path); // $ Alert

  fs.readFileSync(slash(path)); // $ Alert
});

app.get('/dotdot-regexp', (req, res) => {
  let path = pathModule.normalize(req.query.x); // $ Source
  if (pathModule.isAbsolute(path))
    return;
  fs.readFileSync(path); // $ Alert
  if (!path.match(/\./)) {
    fs.readFileSync(path);
  }
  if (!path.match(/\.\./)) {
    fs.readFileSync(path);
  }
  if (!path.match(/\.\.\//)) {
    fs.readFileSync(path);
  }
  if (!path.match(/\.\.\/foo/)) {
    fs.readFileSync(path); // $ Alert
  }
  if (!path.match(/(\.\.\/|\.\.\\)/)) {
    fs.readFileSync(path);
  }
});

app.get('/join-spread', (req, res) => {
  fs.readFileSync(pathModule.join('foo', ...req.query.x.split('/'))); // $ Alert
  fs.readFileSync(pathModule.join(...req.query.x.split('/'))); // $ Alert
});

app.get('/dotdot-matchAll-regexp', (req, res) => {
  let path = pathModule.normalize(req.query.x); // $ Source
  if (pathModule.isAbsolute(path))
    return;
  fs.readFileSync(path); // $ Alert
  if (!path.matchAll(/\./)) {
    fs.readFileSync(path);
  }
  if (!path.matchAll(/\.\./)) {
    fs.readFileSync(path);
  }
  if (!path.matchAll(/\.\.\//)) {
    fs.readFileSync(path);
  }
  if (!path.matchAll(/\.\.\/foo/)) {
    fs.readFileSync(path); // $ Alert
  }
  if (!path.matchAll(/(\.\.\/|\.\.\\)/)) {
    fs.readFileSync(path);
  }
});
