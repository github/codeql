// Test for imports using __dirname
const path = require('path');

// Using __dirname directly
const direct = require(__dirname + '/target.js'); // $ importTarget=DirnameImports/target.js

// Using __dirname with path.join
const withPathJoin = require(path.join(__dirname, 'target.js')); // $ importTarget=DirnameImports/target.js

// Using __dirname with nested path
const nested = require(__dirname + '/nested/target.js'); // $ importTarget=DirnameImports/nested/target.js

// Using __dirname with parent directory
const parent = require(__dirname + '/../import-packages.ts'); // $ importTarget=import-packages.ts

// Using __dirname with path concat and variable
const subdir = 'nested';
const dynamic = require(__dirname + '/' + subdir + '/target.js'); // $ importTarget=DirnameImports/nested/target.js

// Using __dirname in an AddExpr chain
const chainedAdd = require(__dirname + '/' + 'target.js'); // $ importTarget=DirnameImports/target.js
