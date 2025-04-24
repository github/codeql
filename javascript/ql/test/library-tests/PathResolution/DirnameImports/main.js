// Test for imports using __dirname
const path = require('path');

require(__dirname + '/target.js'); // $ importTarget=DirnameImports/target.js
require(__dirname + '/nested/target.js'); // $ importTarget=DirnameImports/nested/target.js
require(__dirname + '/../import-packages.ts'); // $ importTarget=import-packages.ts
require(__dirname + '/' + 'target.js'); // $ importTarget=DirnameImports/target.js

require(path.join(__dirname, 'target.js')); // $ importTarget=DirnameImports/target.js
require(path.resolve(__dirname, 'target.js')); // $ MISSING: importTarget=DirnameImports/target.js

const subdir = 'nested';
require(__dirname + '/' + subdir + '/target.js'); // $ importTarget=DirnameImports/nested/target.js

require(`${__dirname}/target.js`); // $ MISSING: importTarget=DirnameImports/target.js
