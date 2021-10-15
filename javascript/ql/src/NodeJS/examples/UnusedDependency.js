// package.json
{
  "name": "example-package",
  "version": "0.1.0",
  "dependencies": {
    "acorn": "*",
    "esprima": "~2.0.0"
  }
}

// index.js
var acorn = require('acorn'),
    fs = require('fs');
acorn.parse(fs.readFileSync('tst.js'), 'utf-8');