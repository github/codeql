var cp = require('child_process'),
    path = require('path'),
    execa = require("execa");
(function() {
	cp.execFileSync('rm',  ['-rf', path.join(__dirname, "temp")]);
	cp.execSync('rm -rf ' + path.join(__dirname, "temp")); // $ Alert

	execa.shell('rm -rf ' + path.join(__dirname, "temp")); // $ Alert
	execa.shellSync('rm -rf ' + path.join(__dirname, "temp")); // $ Alert

	const safe = "\"" + path.join(__dirname, "temp") + "\"";
	execa.shellSync('rm -rf ' + safe);

	cp.execFileSync('sh', ['-c', 'rm -rf -- "$1"', 'sh', path.join(__dirname, "temp")]);
	cp.execFileSync('sh', ['-c', 'rm -rf ' + path.join(__dirname, "temp"), 'sh', 'unused']); // $ Alert
});
