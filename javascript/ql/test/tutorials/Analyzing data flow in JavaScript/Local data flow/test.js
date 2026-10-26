var fs = require('fs');

var args = process.argv;
var firstArg = args[2];
fs.readFile(firstArg, 'utf8', (err, data) => {
  if (err) throw err;
  console.log(data);
});