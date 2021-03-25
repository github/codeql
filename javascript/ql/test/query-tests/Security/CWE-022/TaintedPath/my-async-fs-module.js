const fs = require('fs');
const {promisify} = require('bluebird');

const methods = [
  'readFile',
  'writeFile',
  'readFileSync',
  'writeFileSync'
];

module.exports = methods.reduce((obj, method) => {
  obj[method] = promisify(fs[method]);
  return obj;
}, {});
