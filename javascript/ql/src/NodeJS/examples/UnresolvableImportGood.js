// package.json
{
  "name": "example-package",
  "version": "0.1.0",
  "dependencies": {
    "acorn": "*"
  }
}

// index.js
var acorn = require('acorn'),
    fs = require('fs');
acorn.parse(fs.readFileSync('tst.js'), 'utf-8');