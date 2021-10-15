const fs = require('fs'),
      path = require('path');

function checkPath(p) {
  p = path.resolve(p);
  return p.startsWith(process.cwd() + path.sep);
}

function readFileHelper(p) {
  if (!checkPath(p))
    return;
  fs.readFile(p,
    'utf8', (err, data) => {
    if (err) throw err;
    console.log(data);
  });
}

readFileHelper(process.argv[2]);
