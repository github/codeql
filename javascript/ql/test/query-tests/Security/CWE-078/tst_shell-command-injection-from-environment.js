var cp = require('child_process'),
    path = require('path');
(function() {
	cp.execFileSync('rm',  ['-rf', path.join(__dirname, "temp")]); // GOOD
	cp.execSync('rm -rf ' + path.join(__dirname, "temp")); // BAD
});
