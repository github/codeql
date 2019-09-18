let overridePath = process.env['SEMMLE_TYPESCRIPT_HOME'];

if (overridePath != null) {
  module.exports = require(overridePath);
} else {
  // Unlike the above, this require() call will be rewritten by rollup.
  module.exports = require('typescript');
}
