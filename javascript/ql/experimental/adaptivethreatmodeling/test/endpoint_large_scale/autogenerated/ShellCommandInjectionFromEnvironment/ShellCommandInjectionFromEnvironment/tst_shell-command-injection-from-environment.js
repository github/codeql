var cp = require('child_process'),
    path = require('path'),
    execa = require("execa");
(function() {
	cp.execFileSync('rm',  ['-rf', path.join(__dirname, "temp")]); // GOOD
	cp.execSync('rm -rf ' + path.join(__dirname, "temp")); // BAD

	execa.shell('rm -rf ' + path.join(__dirname, "temp")); // NOT OK
	execa.shellSync('rm -rf ' + path.join(__dirname, "temp")); // NOT OK

	const safe = "\"" + path.join(__dirname, "temp") + "\"";
	execa.shellSync('rm -rf ' + safe); // OK
});
