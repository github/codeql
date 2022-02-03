var fs = require('fs'),
    express = require('express'),
    url = require('url'),
    sanitize = require('sanitize-filename'),
    pathModule = require('path')
    ;

let app = express();

app.get('/basic', (req, res) => {
  let path = req.query.path;

  fs.readFileSync(path); // NOT OK
  fs.readFileSync('./' + path); // NOT OK
  fs.readFileSync(path + '/index.html'); // NOT OK
  fs.readFileSync(pathModule.join(path, 'index.html')); // NOT OK
  fs.readFileSync(pathModule.join('/home/user/www', path)); // NOT OK
});

app.get('/normalize', (req, res) => {
  let path = pathModule.normalize(req.query.path);

  fs.readFileSync(path); // NOT OK
  fs.readFileSync('./' + path); // NOT OK
  fs.readFileSync(path + '/index.html'); // NOT OK
  fs.readFileSync(pathModule.join(path, 'index.html')); // NOT OK
  fs.readFileSync(pathModule.join('/home/user/www', path)); // NOT OK
});

app.get('/normalize-notAbsolute', (req, res) => {
  let path = pathModule.normalize(req.query.path);

  if (pathModule.isAbsolute(path))
    return;
   
  fs.readFileSync(path); // NOT OK

  if (!path.startsWith("."))
    fs.readFileSync(path); // OK
  else
    fs.readFileSync(path); // NOT OK - wrong polarity
  
  if (!path.startsWith(".."))
    fs.readFileSync(path); // OK
  
  if (!path.startsWith("../"))
    fs.readFileSync(path); // OK

  if (!path.startsWith(".." + pathModule.sep))
    fs.readFileSync(path); // OK
});

app.get('/normalize-noInitialDotDot', (req, res) => {
  let path = pathModule.normalize(req.query.path);
  
  if (path.startsWith(".."))
    return;

  fs.readFileSync(path); // NOT OK - could be absolute

  fs.readFileSync("./" + path); // OK - coerced to relative

  fs.readFileSync(path + "/index.html"); // NOT OK - not coerced

  if (!pathModule.isAbsolute(path))
    fs.readFileSync(path); // OK
  else
    fs.readFileSync(path); // NOT OK
});

app.get('/prepend-normalize', (req, res) => {
  // Coerce to relative prior to normalization
  let path = pathModule.normalize('./' + req.query.path);

  if (!path.startsWith(".."))
    fs.readFileSync(path); // OK
  else
     fs.readFileSync(path); // NOT OK
});

app.get('/absolute', (req, res) => {
  let path = req.query.path;
  
  if (!pathModule.isAbsolute(path))
    return;

  res.write(fs.readFileSync(path)); // NOT OK

  if (path.startsWith('/home/user/www'))
    res.write(fs.readFileSync(path)); // NOT OK - can still contain '../'
});

app.get('/normalized-absolute', (req, res) => {
  let path = pathModule.normalize(req.query.path);
  
  if (!pathModule.isAbsolute(path))
    return;
  
  res.write(fs.readFileSync(path)); // NOT OK

  if (path.startsWith('/home/user/www'))
    res.write(fs.readFileSync(path)); // OK
});

app.get('/combined-check', (req, res) => {
  let path = pathModule.normalize(req.query.path);
  
  // Combined absoluteness and folder check in one startsWith call
  if (path.startsWith("/home/user/www"))
    fs.readFileSync(path); // OK

  if (path[0] !== "/" && path[0] !== ".")
    fs.readFileSync(path); // OK
});

app.get('/realpath', (req, res) => {
  let path = fs.realpathSync(req.query.path);

  fs.readFileSync(path); // NOT OK
  fs.readFileSync(pathModule.join(path, 'index.html')); // NOT OK

  if (path.startsWith("/home/user/www"))
    fs.readFileSync(path); // OK - both absolute and normalized before check
    
  fs.readFileSync(pathModule.join('.', path)); // OK - normalized and coerced to relative
  fs.readFileSync(pathModule.join('/home/user/www', path)); // OK
});

app.get('/coerce-relative', (req, res) => {
  let path = pathModule.join('.', req.query.path);

  if (!path.startsWith('..'))
    fs.readFileSync(path); // OK
  else
    fs.readFileSync(path); // NOT OK
});

app.get('/coerce-absolute', (req, res) => {
  let path = pathModule.join('/home/user/www', req.query.path);

  if (path.startsWith('/home/user/www'))
    fs.readFileSync(path); // OK
  else
    fs.readFileSync(path); // NOT OK
});

app.get('/concat-after-normalization', (req, res) => {
  let path = 'foo/' + pathModule.normalize(req.query.path);

  if (!path.startsWith('..'))
    fs.readFileSync(path); // NOT OK - prefixing foo/ invalidates check
  else
    fs.readFileSync(path); // NOT OK

  if (!path.includes('..'))
    fs.readFileSync(path); // OK
});

app.get('/noDotDot', (req, res) => {
  let path = pathModule.normalize(req.query.path);

  if (path.includes('..'))
    return;

  fs.readFileSync(path); // NOT OK - can still be absolute

  if (!pathModule.isAbsolute(path))
    fs.readFileSync(path); // OK
  else
    fs.readFileSync(path); // NOT OK
});

app.get('/join-regression', (req, res) => {
  let path = req.query.path;

  // Regression test for a specific corner case:
  // Some guard nodes sanitize both branches, but for a different set of flow labels.
  // Verify that this does not break anything.
  if (pathModule.isAbsolute(path)) {path;} else {path;}
  if (path.startsWith('/')) {path;} else {path;}
  if (path.startsWith('/x')) {path;} else {path;}
  if (path.startsWith('.')) {path;} else {path;}

  fs.readFileSync(path); // NOT OK

  if (pathModule.isAbsolute(path))
    fs.readFileSync(path); // NOT OK
  else
    fs.readFileSync(path); // NOT OK

  if (path.includes('..'))
    fs.readFileSync(path); // NOT OK
  else
    fs.readFileSync(path); // NOT OK

  if (!path.includes('..') && !pathModule.isAbsolute(path))
    fs.readFileSync(path); // OK
  else
    fs.readFileSync(path); // NOT OK

  let normalizedPath = pathModule.normalize(path);
  if (normalizedPath.startsWith('/home/user/www'))
    fs.readFileSync(normalizedPath); // OK
  else
    fs.readFileSync(normalizedPath); // NOT OK

  if (normalizedPath.startsWith('/home/user/www') || normalizedPath.startsWith('/home/user/public'))
    fs.readFileSync(normalizedPath); // OK - but flagged anyway [INCONSISTENCY]
  else
    fs.readFileSync(normalizedPath); // NOT OK
});

app.get('/decode-after-normalization', (req, res) => {
  let path = pathModule.normalize(req.query.path);
  
  if (!pathModule.isAbsolute(path) && !path.startsWith('..'))
    fs.readFileSync(path); // OK

  path = decodeURIComponent(path);

  if (!pathModule.isAbsolute(path) && !path.startsWith('..'))
    fs.readFileSync(path); // NOT OK - not normalized
});

app.get('/replace', (req, res) => {
  let path = pathModule.normalize(req.query.path).replace(/%20/g, ' ');
  if (!pathModule.isAbsolute(path)) {
    fs.readFileSync(path); // NOT OK

    path = path.replace(/\.\./g, '');
    fs.readFileSync(path); // OK
  }
});

app.get('/resolve-path', (req, res) => {
  let path = pathModule.resolve(req.query.path);

  fs.readFileSync(path); // NOT OK

  var self = something();
	
  if (path.substring(0, self.dir.length) === self.dir)
    fs.readFileSync(path); // OK
  else
    fs.readFileSync(path); // NOT OK - wrong polarity

  if (path.slice(0, self.dir.length) === self.dir)
    fs.readFileSync(path); // OK
  else
    fs.readFileSync(path); // NOT OK - wrong polarity
});

app.get('/relative-startswith', (req, res) => {
  let path = pathModule.resolve(req.query.path);

  fs.readFileSync(path); // NOT OK

  var self = something();
	
  var relative = pathModule.relative(self.webroot, path);
  if(relative.startsWith(".." + pathModule.sep) || relative == "..") {
    fs.readFileSync(path); // NOT OK! 
  } else {
    fs.readFileSync(path); // OK! 
  }

  let newpath = pathModule.normalize(path);
  var relativePath = pathModule.relative(pathModule.normalize(workspaceDir), newpath);
  if (relativePath.indexOf('..' + pathModule.sep) === 0) {
    fs.readFileSync(newpath); // NOT OK!
  } else {
    fs.readFileSync(newpath); // OK!
  }

  let newpath = pathModule.normalize(path);
  var relativePath = pathModule.relative(pathModule.normalize(workspaceDir), newpath);
  if (relativePath.indexOf('../') === 0) {
    fs.readFileSync(newpath); // NOT OK!
  } else {
    fs.readFileSync(newpath); // OK! 
  }

  let newpath = pathModule.normalize(path);
  var relativePath = pathModule.relative(pathModule.normalize(workspaceDir), newpath);
  if (pathModule.normalize(relativePath).indexOf('../') === 0) {
    fs.readFileSync(newpath); // NOT OK!
  } else {
    fs.readFileSync(newpath); // OK! 
  }

  let newpath = pathModule.normalize(path);
  var relativePath = pathModule.relative(pathModule.normalize(workspaceDir), newpath);
  if (pathModule.normalize(relativePath).indexOf('../')) {
    fs.readFileSync(newpath); // OK!
  } else {
    fs.readFileSync(newpath); // NOT OK! 
  }
});

var isPathInside = require("is-path-inside"),
    pathIsInside = require("path-is-inside");
app.get('/pseudo-normalizations', (req, res) => {
	let path = req.query.path;
	fs.readFileSync(path); // NOT OK
	if (isPathInside(path, SAFE)) {
		fs.readFileSync(path); // OK
		return;
	} else {
		fs.readFileSync(path); // NOT OK

	}
	if (pathIsInside(path, SAFE)) {
		fs.readFileSync(path); // NOT OK - can be of the form 'safe/directory/../../../etc/passwd'
		return;
	} else {
		fs.readFileSync(path); // NOT OK

	}

	let normalizedPath = pathModule.join(SAFE, path);
	if (pathIsInside(normalizedPath, SAFE)) {
		fs.readFileSync(normalizedPath); // OK
		return;
	} else {
		fs.readFileSync(normalizedPath); // NOT OK
	}

	if (pathIsInside(normalizedPath, SAFE)) {
		fs.readFileSync(normalizedPath); // OK
		return;
	} else {
		fs.readFileSync(normalizedPath); // NOT OK

	}

});

app.get('/yet-another-prefix', (req, res) => {
	let path = pathModule.resolve(req.query.path);

	fs.readFileSync(path); // NOT OK

	var abs = pathModule.resolve(path); 

	if (abs.indexOf(root) !== 0) {
		fs.readFileSync(path); // NOT OK
		return;
    }
	fs.readFileSync(path); // OK
});

var rootPath = process.cwd();
app.get('/yet-another-prefix2', (req, res) => {
  let path = req.query.path;

  fs.readFileSync(path); // NOT OK

  var requestPath = pathModule.join(rootPath, path);

  var targetPath;
  if (!allowPath(requestPath, rootPath)) {
    targetPath = rootPath;
    fs.readFileSync(requestPath); // NOT OK
  } else {
    targetPath = requestPath;
    fs.readFileSync(requestPath); // OK
  }
  fs.readFileSync(targetPath); // OK

  function allowPath(requestPath, rootPath) {
    return requestPath.indexOf(rootPath) === 0;
  }
});