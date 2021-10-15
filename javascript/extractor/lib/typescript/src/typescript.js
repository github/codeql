let overridePath = process.env['SEMMLE_TYPESCRIPT_HOME'];

if (overridePath != null) {
  module.exports = require(overridePath);
} else {
  module.exports = require('typescript');
}
