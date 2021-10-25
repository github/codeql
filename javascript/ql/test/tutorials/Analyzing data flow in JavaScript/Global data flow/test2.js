const fs = require('fs'),
      path = require('path');

function checkPath(p) {
  p = path.resolve(p);
  if (!p.startsWith(process.cwd() + path.sep))
    throw new Error("Invalid path " + p);
  return p;
}

function readFileHelper(p) {
  p = checkPath(p);
  fs.readFile(p,
    'utf8', (err, data) => {
    if (err) throw err;
    console.log(data);
  });
}

readFileHelper(process.argv[2]);
