// package.json
{
  "name": "example-package",
  "version": "0.1.0"
}

// index.js
var acorn = require('acorn'),
    fs = require('fs');
acorn.parse(fs.readFileSync('tst.js'), 'utf-8');