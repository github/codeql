var express = require('express');
var child_process = require('child_process');
var execSync = child_process.execSync;
var exec = child_process.exec;
var spawn = child_process.spawn;
var spawnSync = child_process.spawnSync;
var fs = require('fs');
var app = express();

function readStatus(id) {
	exec("cat /proc/" + id + "/status", function (err, out) { // NOT OK
		console.log(out);
	});
};

var basePath = '/foo/bar';
app.get('/:data', function (req, res) {
	res.send(execSync('cat ' + basePath + req.params.data).toString()); // OK [but flagged] - caught by command-injection
});

spawn('cat', ['package.json']); // NOT OK

spawn('/bin/cat', ['package.json']); // NOT 

spawn('/bin/cat', [someValue]); // NOT OK
spawn('sudo /bin/cat', [someValue]); // NOT OK
spawn('sudo cat', [someValue]); // NOT OK  

child_process.spawnSync('cat', [someValue]); // NOT OK

child_process.execSync('cat package.json | wc -l'); // OK - pipes!

const cat = child_process.spawn('cat') // OK - benign use (usually pipe to and from).

spawn('cat', ['package.json']); // NOT OK.

exec('cat *.js') // OK - wildcard use.
exec('cat *.js | wc -l') // OK - wildcard use and pipes!
exec('cat *.js | wc -l', { cwd: './' }, function () { }); // OK - wildcard and pipes

spawnSync('cat', ['/proc/cpuinfo']) // NOT OK.

exec(`cat ${path.join(__dirname, 'package.json')} | sort | uniq`, () => {}); // OK: pipes

execSync('cat /proc/cpuinfo').toString(); // NOT OK.

var cmd = "cat /proc/cpuinfo"
execSync(cmd); // NOT OK

execSync("cat /proc/cpuinfo | grep -c '" + someValue + "'"); // OK - pipes

function cat(file) {
	return execSync('cat ' + file).toString(); // NOT OK [flagged]
}

execSync(`cat ${files.join(' ')} > ${outFile}`); // NOT OK [flagged]

var cmd = 'cat package.json | grep'
exec(cmd); // OK - pipes!

execSync("sudo cat " + newpath + "*.js | grep foo").toString(); // OK - wildcard and pipes

execSync(`cat ${newpath}`); // NOT OK

exec("cat /proc/cpuinfo | grep name"); // OK - pipes

execSync(`cat ${newpath} | ${othertool}`); // OK - pipes

execSync("sh -c 'cat " + newpath + "'"); // NOT OK. [but not flagged]

exec(` cat ${newpath}`) // NOT OK

exec(` cat ${newpath} | grep foo`) // OK - pipes