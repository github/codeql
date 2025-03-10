var express = require('express');
var child_process = require('child_process');
var execSync = child_process.execSync;
var exec = child_process.exec;
var spawn = child_process.spawn;
var spawnSync = child_process.spawnSync;
var fs = require('fs');
var app = express();

exec("cat foo/bar", function (err, out) {}); // $ Alert

exec("cat /proc/" + id + "/status", function (err, out) { // $ Alert
	console.log(out);
});

execSync('cat /proc/cpuinfo').toString(); // $ Alert

execSync(`cat ${newpath}`) // $ Alert

execSync('cat package.json | wc -l'); // OK - pipes!

execSync('cat /proc/cpuinfo /foo/bar').toString(); // OK - multiple files.

execSync(`cat ${newpath} /foo/bar`).toString(); // OK - multiple files.

exec(`cat ${newpath} | grep foo`, function (err, out) { }) // OK - pipes

execSync(`cat ${newpath}`, {uid: 1000}) // OK - non trivial options

exec('cat *.js | wc -l', { cwd: './' }, function (err, out) { }); // OK - wildcard and pipes

execSync(`cat foo/bar/${newpath}`); // $ Alert - "encoding" is used EXACTLY the same way in fs.readFileSync

execSync(`cat foo/bar/${newpath}`, {encoding: 'utf8'}); // $ Alert - "encoding" is used EXACTLY the same way in fs.readFileSync

execSync("/bin/cat /proc/cpuinfo", { uid: 1000, gid: 1000, encoding: 'utf8'}); // OK - (fs.readFileSync cannot emulate uid / gid))

execSync('cat /proc/cpuinfo > foo/bar/baz').toString();

execSync(`cat ${newpath} > ${destpath}`).toString();

execSync(`cat ${files.join(' ')} > ${outFile}`);

execSync(`cat ${files.join(' ')}`); // $ SPURIOUS: Alert - not just a simple file read

exec("cat /proc/cpuinfo | grep name"); // OK - pipes

execSync(`cat ${newpath} | ${othertool}`); // OK - pipes

function cat(file) {
	return execSync('cat ' + file).toString(); // $ Alert
}

execSync("sh -c 'cat " + newpath + "'"); // $ MISSING: Alert

var execFile = child_process.execFile;
var execFileSync = child_process.execFileSync;

execFile('/bin/cat', [ 'pom.xml' ], function(error, stdout, stderr ) { // $ Alert
  // Not using stderr
  console.log(stdout);
});

execFile('/bin/cat', [ 'pom.xml' ], function(error, stdout, stderr ) { // OK - - stderr is used.
  console.log(stderr); 
});


execFile('/bin/cat', [ 'pom.xml' ],  {encoding: 'utf8'}, function(error, stdout, stderr ) { // $ Alert
  // Not using stderr
  console.log(stdout);
});

execFileSync('/bin/cat', [ 'pom.xml' ],  {encoding: 'utf8'}); // $ Alert

execFileSync('/bin/cat', [ 'pom.xml' ]);  // $ Alert

var opts = {encoding: 'utf8'};
execFileSync('/bin/cat', [ 'pom.xml' ],  opts); // $ Alert

var anOptsFileNameThatIsTooLongToBePrintedByToString = {encoding: 'utf8'};
execFileSync('/bin/cat', [ 'pom.xml' ],  anOptsFileNameThatIsTooLongToBePrintedByToString); // $ Alert

execFileSync('/bin/cat', [ 'pom.xml' ],  {encoding: 'someEncodingValueThatIsCompletelyBogusAndTooLongForToString'}); // $ Alert

execFileSync('/bin/cat', [ "foo/" + newPath + "bar" ],  {encoding: 'utf8'}); // $ Alert

execSync('cat /proc/cpuinfo' + foo).toString(); // $ Alert

execFileSync('/bin/cat', [ `foo/bar/${newpath}` ]); // $ Alert

execFileSync('node', [ `foo/bar/${newpath}` ]); // OK - not a call to cat

exec("cat foo/bar", function (err, out) {}); // $ Alert

exec("cat foo/bar", (err, out) => {console.log(out)}); // $ Alert

exec("cat foo/bar", (err, out) => doSomethingWith(out)); // $ Alert

execFileSync('/bin/cat', [ 'pom.xml' ],  unknownOptions); // OK - unknown options.

exec("node foo/bar", (err, out) => doSomethingWith(out)); // OK - Not a call to cat

execFileSync('node', [ `cat` ]); // OK - not a call to cat

exec("cat foo/bar&", function (err, out) {}); // OK - contains &
exec("cat foo/bar,", function (err, out) {}); // OK - contains ,
exec("cat foo/bar$", function (err, out) {}); // OK - contains $
exec("cat foo/bar`", function (err, out) {}); // OK - contains `

spawn('cat', { stdio: ['pipe', stdin, 'inherit'] }); // OK - Non trivial use. (But weird API use.)

(function () {
  const cat = spawn('cat', [filename]); // OK - non trivial use.
  cat.stdout.on('data', (data) => {
    res.write(data);
  });
  cat.stdout.on('end', () => res.end());
})();

var dead = exec("cat foo/bar", (err, out) => {console.log(out)}); // $ Alert

var notDead = exec("cat foo/bar", (err, out) => {console.log(out)});
console.log(notDead);

(function () {
  var dead = exec("cat foo/bar", (err, out) => {console.log(out)}); // $ Alert

  someCall(
	exec("cat foo/bar", (err, out) => {console.log(out)}) // OK - non-trivial use of returned proccess.
  );

  return exec("cat foo/bar", (err, out) => {console.log(out)}); // OK - non-trivial use of returned proccess.
})();

const stdout2 = execSync('cat /etc/dnsmasq.conf', { // $ Alert
  encoding: 'utf8'
});

exec('/bin/cat', function (e, s) {});

spawn("cat")


var shelljs = require("shelljs");
shelljs.exec("cat foo/bar", (err, out) => {console.log(out)}); // $ Alert
shelljs.exec("cat foo/bar", {encoding: 'utf8'}); // $ Alert
shelljs.exec("cat foo/bar", {encoding: 'utf8'}, (err, out) => {console.log(out)}); // $ Alert

let cspawn = require('cross-spawn');
cspawn('cat', ['foo/bar'], { encoding: 'utf8' }); // $ Alert
cspawn('cat', ['foo/bar'], { encoding: 'utf8' }, (err, out) => {console.log(out)}); // $ Alert
cspawn('cat', ['foo/bar'], (err, out) => {console.log(out)}); // $ Alert
cspawn('cat', ['foo/bar']); // $ Alert
cspawn('cat', (err, out) => {console.log(out)});
cspawn('cat', { encoding: 'utf8' });
 
let myResult = cspawn.sync('cat', ['foo/bar']); // $ Alert
let myResult = cspawn.sync('cat', ['foo/bar'], { encoding: 'utf8' }); // $ Alert

var execmod = require('exec');
execmod("cat foo/bar", (err, out) => {console.log(out)}); // $ Alert
execmod("cat foo/bar", {encoding: 'utf8'}); // $ Alert
execmod("cat foo/bar", {encoding: 'utf8'}, (err, out) => {console.log(out)}); // $ Alert

  