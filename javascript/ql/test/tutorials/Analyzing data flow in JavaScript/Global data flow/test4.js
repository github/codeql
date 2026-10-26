const fs = require('fs'),
path = require('path'),
resolveSymlinks = require('resolve-symlinks');

function readFileHelper(p) {
p = resolveSymlinks(p);
fs.readFile(p,
'utf8', (err, data) => {
if (err) throw err;
console.log(data);
});
}

readFileHelper(process.argv[2]);
