var cp = require("child_process")

module.exports = function (name) {
	cp.exec("rm -rf " + name); // NOT OK

	cp.execFile(name, [name]); // OK
	cp.execFile(name, name); // OK
};

module.exports.foo = function (name) {
	cp.exec("rm -rf " + name); // NOT OK
}

module.exports.foo.bar = function (name) {
	cp.exec("rm -rf " + name); // NOT OK
}

function cla() { }
cla.prototype.method = function (name) {
	cp.exec("rm -rf " + name); // NOT OK
}
module.exports = new cla();


function cla2() { }
cla2.prototype.method = function (name) {
	cp.exec("rm -rf " + name); // NOT OK
}
module.exports.bla = new cla2();

module.exports.lib2 = require("./lib2.js")

class Cla3 {
	constructor(name) {
		cp.exec("rm -rf " + name); // NOT OK
	}
	static foo(name) {
		cp.exec("rm -rf " + name); // NOT OK
	}
	bar(name) {
		cp.exec("rm -rf " + name); // NOT OK

		cp.exec("rm -rf " + notASource); // OK
	}
}

module.exports.cla3 = Cla3;

module.exports.mz = function (name) {
	require("mz/child_process").exec("rm -rf " + name); // NOT OK.
}

module.exports.flow = function (name) {
	var cmd1 = "rm -rf " + name; // NOT OK.
	cp.exec(cmd1); 

	var cmd2 = "rm -rf " + name;  // NOT OK.
	function myExec(cmd) {
		cp.exec(cmd);
	}
	myExec(cmd2);
}

module.exports.stringConcat = function (name) {
	cp.exec("rm -rf " + name); // NOT OK.

	cp.exec(name); // OK.

	cp.exec("for foo in (" + name + ") do bla end"); // OK.

	cp.exec("cat /foO/BAR/" + name) // NOT OK.

	cp.exec("cat \"" + name + "\"") // NOT OK.

	cp.exec("cat '" + name + "'") // NOT OK.

	cp.exec("cat '/foo/bar" + name + "'") // NOT OK.

	cp.exec(name + " some file") // OK.    
}

module.exports.arrays = function (name) {
	cp.exec("rm -rf " + name); // NOT OK.

	var args1 = ["node"];
	args1.push(name); // NOT OK.
	cp.exec(args1.join(" "));

	cp.exec(["rm -rf", name].join(" ")); // NOT OK.

	cp.exec(["rm -rf", "\"" + name + "\""].join(" ")); // NOT OK.

	cp.execFile("rm", ["-rf", name]); // OK
}

var util = require("util");
module.exports.format = function (name) {
	cp.exec(util.format("rm -rf %s", name)); // NOT OK

	cp.exec(util.format("rm -rf '%s'", name)); // NOT OK

	cp.exec(util.format("rm -rf '/foo/bar/%s'", name)); // NOT OK

	cp.exec(util.format("%s foo/bar", name)); // OK

	cp.exec(util.format("for foo in (%s) do bar end", name)); // OK

	cp.exec(require("printf")('rm -rf %s', name)); // NOT OK
}

module.exports.valid = function (name) {
	cp.exec("rm -rf " + name); // NOT OK

	if (!isValidName(name)) {
		return;
	}
	cp.exec("rm -rf " + name); // OK
}

module.exports.safe = function (name) {
	cp.exec("rm -rf " + name); // NOT OK

	if (!isSafeName(name)) {
		return;
	}
	cp.exec("rm -rf " + name); // OK
}

class Cla4 {
	wha(name) {
		cp.exec("rm -rf " + name); // NOT OK
	}

	static bla(name) {
		cp.exec("rm -rf " + name); // OK - not exported
	}
	constructor(name) {
		cp.exec("rm -rf " + name); // OK - not exported
	}
}
module.exports.cla4 = new Cla4();

function Cla5(name) {
	cp.exec("rm -rf " + name); // OK - not exported
}
module.exports.cla5 = new Cla5();

module.exports.indirect = function (name) {
	let cmd = "rm -rf " + name; // NOT OK
	let sh = "sh";
	let args = ["-c", cmd];
	cp.spawn(sh, args, cb);
}

module.exports.indirect2 = function (name) {
	let cmd = name;
	let sh = "sh";
	let args = ["-c", cmd];
	cp.spawn(sh, args, cb); // OK

	let cmd2 = "rm -rf " + name;
	var args2 = [cmd2];
	cp.spawn(
		'cmd.exe',
		['/C', editor].concat(args2),
		{ stdio: 'inherit' }
	);
}

module.exports.cmd = function (command, name) {
	cp.exec("fo | " + command); // OK

	cp.exec("fo | " + name); // NOT OK

}

module.exports.sanitizer = function (name) {
	var sanitized = "'" + name.replace(/'/g, "'\\''") + "'"
	cp.exec("rm -rf " + sanitized); // OK

	var broken = "'" + name.replace(/'/g, "'\''") + "'"
	cp.exec("rm -rf " + broken); // NOT OK
}

var path = require("path");
module.exports.guard = function (name) {
	cp.exec("rm -rf " + name); // NOT OK

	if (!path.exist(name)) {
		cp.exec("rm -rf " + name); // NOT OK
		return;
	}
	cp.exec("rm -rf " + name); // OK
}

module.exports.blacklistOfChars = function (name) {
	cp.exec("rm -rf " + name); // NOT OK

	if (/[^A-Za-z0-9_\/:=-]/.test(name)) {
		cp.exec("rm -rf " + name); // NOT OK
	} else {
		cp.exec("rm -rf " + name); // OK
	}
}

module.exports.whitelistOfChars = function (name) {
	cp.exec("rm -rf " + name); // NOT OK

	if (/^[A-Za-z0-9_\/:=-]$/.test(name)) {
		cp.exec("rm -rf " + name); // OK
	} else {
		cp.exec("rm -rf " + name); // NOT OK
	}
}

module.exports.blackList2 = function (name) {
	cp.exec("rm -rf " + name); // NOT OK

	if (!/^([a-zA-Z0-9]+))?$/.test(name)) {
		cp.exec("rm -rf " + name); // NOT OK
		process.exit(-1);
	}

	cp.exec("rm -rf " + name); // OK - but FP due to tracking flow through `process.exit()`. [INCONSISTENCY]
}

module.exports.accessSync = function (name) {
	cp.exec("rm -rf " + name); // NOT OK

	try {
		path.accessSync(name);
	} catch (e) {
		return;
	}

	cp.exec("rm -rf " + name); // OK - but FP due to `path.accessSync` not being recognized as a sanitizer. [INCONSISTENCY]
}

var cleanInput = function (s) {
	if (/[^A-Za-z0-9_\/:=-]/.test(s)) {
		s = "'" + s.replace(/'/g, "'\\''") + "'";
		s = s.replace(/^(?:'')+/g, '') // unduplicate single-quote at the beginning
			.replace(/\\'''/g, "\\'"); // remove non-escaped single-quote if there are enclosed between 2 escaped
	}
	return s;
}

module.exports.goodSanitizer = function (name) {
	cp.exec("rm -rf " + name); // NOT OK

	var cleaned = cleanInput(name);

	cp.exec("rm -rf " + cleaned); // OK
}

var fs = require("fs");
module.exports.guard2 = function (name) {
	cp.exec("rm -rf " + name); // NOT OK

	if (!fs.existsSync("prefix/" + name)) {
		cp.exec("rm -rf prefix/" + name); // NOT OK
		return;
	}
	cp.exec("rm -rf prefix/" + name); // OK
}

module.exports.sanitizerProperty = function (obj) {
	cp.exec("rm -rf " + obj.version); // NOT OK

	obj.version = "";

	cp.exec("rm -rf " + obj.version); // OK
}

module.exports.Foo = class Foo {
	start(opts) {
		cp.exec("rm -rf " + opts.bla); // NOT OK
		this.opts = {};
		this.opts.bla = opts.bla

		cp.exec("rm -rf " + this.opts.bla); // NOT OK - but FN [INCONSISTENCY]
	}
}

function sanitizeShellString(str) {
  let result = str;
  result = result.replace(/>/g, "");
  result = result.replace(/</g, "");
  result = result.replace(/\*/g, "");
  result = result.replace(/\?/g, "");
  result = result.replace(/\[/g, "");
  result = result.replace(/\]/g, "");
  result = result.replace(/\|/g, "");
  result = result.replace(/\`/g, "");
  result = result.replace(/$/g, "");
  result = result.replace(/;/g, "");
  result = result.replace(/&/g, "");
  result = result.replace(/\)/g, "");
  result = result.replace(/\(/g, "");
  result = result.replace(/\$/g, "");
  result = result.replace(/#/g, "");
  result = result.replace(/\\/g, "");
  result = result.replace(/\n/g, "");
  return result
}

module.exports.sanitizer2 = function (name) {
  cp.exec("rm -rf " + name); // NOT OK

  var sanitized = sanitizeShellString(name);
  cp.exec("rm -rf " + sanitized); // OK
}

module.exports.typeofcheck = function (name) {
	cp.exec("rm -rf " + name); // NOT OK
	
	if (typeof name === "undefined") {
		cp.exec("rm -rf " + name); // OK
	} else {
		cp.exec("rm -rf " + name); // NOT OK
	}
}

module.exports.typeofcheck = function (arg) {
	var cmd = "MyWindowCommand | findstr /i /c:" + arg; // NOT OK
	cp.exec(cmd); 
}

function id(x) {
	return x;
}

module.exports.id = id;

module.exports.unproblematic = function() {
	cp.exec("rm -rf " + id("test")); // OK
};

module.exports.problematic = function(n) {
	cp.exec("rm -rf " + id(n)); // NOT OK
};

module.exports.typeofNumber = function(n) {
	if (typeof n === "number") {
		cp.exec("rm -rf " + n); // OK
	}
};

function boundProblem(safe, unsafe) {
	cp.exec("rm -rf " + safe); // OK
	cp.exec("rm -rf " + unsafe); // NOT OK
}

Object.defineProperty(module.exports, "boundProblem", {
	get: function () {
		return boundProblem.bind(this, "safe");
	}
});

function MyTrainer(opts) {
	this.learn_args = opts.learn_args
}

MyTrainer.prototype = {
	train: function() {
		var command = "learn " + this.learn_args + " " + model; // NOT OK
		cp.exec(command); 
	}
};
module.exports.MyTrainer = MyTrainer;


function yetAnohterSanitizer(str) {
	const s = str || '';
	let result = '';
	for (let i = 0; i <= 2000; i++) {
		if (!(s[i] === undefined ||
			s[i] === '>' ||
			s[i] === '<' ||
			s[i] === '*' ||
			s[i] === '?' ||
			s[i] === '[' ||
			s[i] === ']' ||
			s[i] === '|' ||
			s[i] === '˚' ||
			s[i] === '$' ||
			s[i] === ';' ||
			s[i] === '&' ||
			s[i] === '(' ||
			s[i] === ')' ||
			s[i] === ']' ||
			s[i] === '#' ||
			s[i] === '\\' ||
			s[i] === '\t' ||
			s[i] === '\n' ||
			s[i] === '\'' ||
			s[i] === '`' ||
			s[i] === '"')) {
			result = result + s[i];
		}
	}
	return result;
}

module.exports.sanitizer3 = function (name) {
	cp.exec("rm -rf " + name); // NOT OK

	var sanitized = yetAnohterSanitizer(name);
	cp.exec("rm -rf " + sanitized); // OK
}

const cp = require("child_process");
const spawn = cp.spawn;
module.exports.shellOption = function (name) {
	cp.exec("rm -rf " + name); // NOT OK

	cp.execFile("rm", ["-rf", name], {shell: true}, (err, out) => {}); // NOT OK
	cp.spawn("rm", ["-rf", name], {shell: true}); // NOT OK
	cp.execFileSync("rm", ["-rf", name], {shell: true}); // NOT OK
	cp.spawnSync("rm", ["-rf", name], {shell: true}); // NOT OK

	const SPAWN_OPT = {shell: true};

	spawn("rm", ["first", name], SPAWN_OPT); // NOT OK
	var arr = [];
	arr.push(name); // NOT OK
	spawn("rm", arr, SPAWN_OPT); 
	spawn("rm", build("node", (name ? name + ':' : '') + '-'), SPAWN_OPT);  // This is bad, but the alert location is down in `build`.
}

function build(first, last) {
	var arr = [];
	if (something() === 'gm')
		arr.push('convert');
	first && arr.push(first);
	last && arr.push(last); // NOT OK
	return arr;
};

var asyncExec = require("async-execute");
module.exports.asyncStuff = function (name) {
	asyncExec("rm -rf " + name); // NOT OK
}

const myFuncs = {
	myFunc: function (name) {
		asyncExec("rm -rf " + name); // NOT OK
	}
};

module.exports.blabity = {};

Object.defineProperties(
	module.exports.blabity,
	Object.assign(
		{},
		Object.entries(myFuncs).reduce(
			(props, [ key, value ]) => Object.assign(
				props,
				{
					[key]: {
						value,
						configurable: true,
					},
				},
			),
			{}
		)
	)
);

const path = require('path');
const {promisify} = require('util');

const exec = promisify(require('child_process').exec);

module.exports = function check(config) {
    const cmd = path.join(config.installedPath, 'myBinary -v'); // NOT OK
    return exec(cmd);
}

module.exports.splitConcat = function (name) {
	let args = ' my name is ' + name; // NOT OK
	let cmd = 'echo';
	cp.exec(cmd + args);
}

module.exports.myCommand = function (myCommand) {
	let cmd = `cd ${cwd} ; ${myCommand}`; // OK - the parameter name suggests that it is purposely a shell command.
	cp.exec(cmd);
}

(function () {
	var MyThing = {
		cp: require('child_process')
	};

	module.exports.myIndirectThing = function (name) {
		MyThing.cp.exec("rm -rf " + name); // NOT OK
	}
});
  

var imp = require('./isImported');
for (var name in imp){
  module.exports[name] = imp[name];
}

module.exports.sanitizer4 = function (name) {
	cp.exec("rm -rf " + name); // NOT OK

	if (isNaN(name)) {
		cp.exec("rm -rf " + name); // NOT OK
	} else {
		cp.exec("rm -rf " + name); // OK
	}

	if (isNaN(parseInt(name))) {
		cp.exec("rm -rf " + name); // NOT OK
	} else {
		cp.exec("rm -rf " + name); // OK
	}

	if (isNaN(+name)) {
		cp.exec("rm -rf " + name); // NOT OK
	} else {
		cp.exec("rm -rf " + name); // OK
	}

	if (isNaN(parseInt(name, 10))) {
		cp.exec("rm -rf " + name); // NOT OK
	} else {
		cp.exec("rm -rf " + name); // OK
	}

	if (isNaN(name - 0)) {
		cp.exec("rm -rf " + name); // NOT OK
	} else {
		cp.exec("rm -rf " + name); // OK
	}

	if (isNaN(name | 0)) { // <- not a sanitizer
		cp.exec("rm -rf " + name); // NOT OK
	} else {
		cp.exec("rm -rf " + name); // NOT OK
	}
}
