var express = require('express');
var child_process = require('child_process');
var execSync = child_process.execSync;
var exec = child_process.exec;
var spawn = child_process.spawn;
var spawnSync = child_process.spawnSync;
var fs = require('fs');
var app = express();

exec("cat foo/bar", function (err, out) {}); // NOT OK

exec("cat /proc/" + id + "/status", function (err, out) { // NOT OK
	console.log(out);
});

execSync('cat /proc/cpuinfo').toString(); // NOT OK.

execSync(`cat ${newpath}`) // NOT OK

execSync('cat package.json | wc -l'); // OK - pipes!

execSync('cat /proc/cpuinfo /foo/bar').toString(); // OK multiple files.

execSync(`cat ${newpath} /foo/bar`).toString(); // OK multiple files.

exec(`cat ${newpath} | grep foo`, function (err, out) { }) // OK - pipes

execSync(`cat ${newpath}`, {uid: 1000}) // OK - non trivial options

exec('cat *.js | wc -l', { cwd: './' }, function (err, out) { }); // OK - wildcard and pipes

execSync(`cat foo/bar/${newpath}`); // NOT OK ("encoding" is used EXACTLY the same way in fs.readFileSync)

execSync(`cat foo/bar/${newpath}`, {encoding: 'utf8'}); // NOT OK ("encoding" is used EXACTLY the same way in fs.readFileSync)

execSync("/bin/cat /proc/cpuinfo", { uid: 1000, gid: 1000, encoding: 'utf8'}); // OK (fs.readFileSync cannot emulate uid / gid))

execSync('cat /proc/cpuinfo > foo/bar/baz').toString(); // OK.

execSync(`cat ${newpath} > ${destpath}`).toString(); // OK.

execSync(`cat ${files.join(' ')} > ${outFile}`); // OK

execSync(`cat ${files.join(' ')}`); // OK  - but flagged - not just a simple file read [INCONSISTENCY]

exec("cat /proc/cpuinfo | grep name"); // OK - pipes

execSync(`cat ${newpath} | ${othertool}`); // OK - pipes

function cat(file) {
	return execSync('cat ' + file).toString(); // NOT OK
}

execSync("sh -c 'cat " + newpath + "'"); // NOT OK - but not flagged [INCONSISTENCY]

var execFile = child_process.execFile;
var execFileSync = child_process.execFileSync;

execFile('/bin/cat', [ 'pom.xml' ], function(error, stdout, stderr ) { // NOT OK
  // Not using stderr
  console.log(stdout);
});

execFile('/bin/cat', [ 'pom.xml' ], function(error, stdout, stderr ) { // OK. - stderr is used.
  console.log(stderr); 
});


execFile('/bin/cat', [ 'pom.xml' ],  {encoding: 'utf8'}, function(error, stdout, stderr ) { // NOT OK
  // Not using stderr
  console.log(stdout);
});

execFileSync('/bin/cat', [ 'pom.xml' ],  {encoding: 'utf8'}); // NOT OK

execFileSync('/bin/cat', [ 'pom.xml' ]);  // NOT OK

var opts = {encoding: 'utf8'};
execFileSync('/bin/cat', [ 'pom.xml' ],  opts); // NOT OK

var anOptsFileNameThatIsTooLongToBePrintedByToString = {encoding: 'utf8'};
execFileSync('/bin/cat', [ 'pom.xml' ],  anOptsFileNameThatIsTooLongToBePrintedByToString); // NOT OK

execFileSync('/bin/cat', [ 'pom.xml' ],  {encoding: 'someEncodingValueThatIsCompletelyBogusAndTooLongForToString'}); // NOT OK

execFileSync('/bin/cat', [ "foo/" + newPath + "bar" ],  {encoding: 'utf8'}); // NOT OK

execSync('cat /proc/cpuinfo' + foo).toString(); // NOT OK.

execFileSync('/bin/cat', [ `foo/bar/${newpath}` ]); // NOT OK

execFileSync('node', [ `foo/bar/${newpath}` ]); // OK - not a call to cat

exec("cat foo/bar", function (err, out) {}); // NOT OK

exec("cat foo/bar", (err, out) => {console.log(out)}); // NOT OK

exec("cat foo/bar", (err, out) => doSomethingWith(out)); // NOT OK

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

var dead = exec("cat foo/bar", (err, out) => {console.log(out)}); // NOT OK

var notDead = exec("cat foo/bar", (err, out) => {console.log(out)}); // OK
console.log(notDead);

(function () {
  var dead = exec("cat foo/bar", (err, out) => {console.log(out)}); // NOT OK

  someCall(
	exec("cat foo/bar", (err, out) => {console.log(out)}) // OK - non-trivial use of returned proccess.
  );

  return exec("cat foo/bar", (err, out) => {console.log(out)}); // OK - non-trivial use of returned proccess.
})();

const stdout2 = execSync('cat /etc/dnsmasq.conf', { // NOT OK.
  encoding: 'utf8'
});

exec('/bin/cat', function (e, s) {});  // OK

spawn("cat") // OK  


var shelljs = require("shelljs");
shelljs.exec("cat foo/bar", (err, out) => {console.log(out)}); // NOT OK
shelljs.exec("cat foo/bar", {encoding: 'utf8'}); // NOT OK
shelljs.exec("cat foo/bar", {encoding: 'utf8'}, (err, out) => {console.log(out)}); // NOT OK

let cspawn = require('cross-spawn');
cspawn('cat', ['foo/bar'], { encoding: 'utf8' }); // NOT OK
cspawn('cat', ['foo/bar'], { encoding: 'utf8' }, (err, out) => {console.log(out)}); // NOT OK
cspawn('cat', ['foo/bar'], (err, out) => {console.log(out)}); // NOT OK
cspawn('cat', ['foo/bar']); // NOT OK
cspawn('cat', (err, out) => {console.log(out)}); // OK
cspawn('cat', { encoding: 'utf8' }); // OK
 
let myResult = cspawn.sync('cat', ['foo/bar']); // NOT OK
let myResult = cspawn.sync('cat', ['foo/bar'], { encoding: 'utf8' }); // NOT OK

var execmod = require('exec');
execmod("cat foo/bar", (err, out) => {console.log(out)}); // NOT OK
execmod("cat foo/bar", {encoding: 'utf8'}); // NOT OK
execmod("cat foo/bar", {encoding: 'utf8'}, (err, out) => {console.log(out)}); // NOT OK

  