var cp = require("child_process")

module.exports.blah = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert Sink

	cp.execFile(name, [name]);
	cp.execFile(name, name);
};

module.exports.foo = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert Sink
}

module.exports.foo.bar = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert Sink
}

function cla() { }
cla.prototype.method = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert Sink
}
module.exports.cla = new cla();


function cla2() { }
cla2.prototype.method = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert Sink
}
module.exports.bla = new cla2();

module.exports.lib2 = require("./lib2.js")

class Cla3 {
	constructor(name) { // $ Source
		cp.exec("rm -rf " + name); // $ Alert Sink
	}
	static foo(name) { // $ Source
		cp.exec("rm -rf " + name); // $ Alert Sink
	}
	bar(name) { // $ Source
		cp.exec("rm -rf " + name); // $ Alert Sink

		cp.exec("rm -rf " + notASource);
	}
}

module.exports.cla3 = Cla3;

module.exports.mz = function (name) { // $ Source
	require("mz/child_process").exec("rm -rf " + name); // $ Alert Sink
}

module.exports.flow = function (name) { // $ Source
	var cmd1 = "rm -rf " + name; // $ Alert Sink
	cp.exec(cmd1); 

	var cmd2 = "rm -rf " + name;  // $ Alert Sink
	function myExec(cmd) {
		cp.exec(cmd);
	}
	myExec(cmd2);
}

module.exports.stringConcat = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert Sink

	cp.exec(name);

	cp.exec("for foo in (" + name + ") do bla end"); // $ Alert Sink

	cp.exec("cat /foO/BAR/" + name) // $ Alert Sink

	cp.exec("cat \"" + name + "\"") // $ Alert Sink

	cp.exec("cat '" + name + "'") // $ Alert Sink

	cp.exec("cat '/foo/bar" + name + "'") // $ Alert Sink

	cp.exec(name + " some file")
}

module.exports.arrays = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert Sink

	var args1 = ["node"];
	args1.push(name); // $ Alert
	cp.exec(args1.join(" "));

	cp.exec(["rm -rf", name].join(" ")); // $ Alert

	cp.exec(["rm -rf", "\"" + name + "\""].join(" ")); // $ Alert

	cp.execFile("rm", ["-rf", name]);
}

var util = require("util");
module.exports.format = function (name) { // $ Source
	cp.exec(util.format("rm -rf %s", name)); // $ Alert

	cp.exec(util.format("rm -rf '%s'", name)); // $ Alert

	cp.exec(util.format("rm -rf '/foo/bar/%s'", name)); // $ Alert

	cp.exec(util.format("%s foo/bar", name));

	cp.exec(util.format("for foo in (%s) do bar end", name));

	cp.exec(require("printf")('rm -rf %s', name)); // $ Alert
}

module.exports.valid = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert Sink

	if (!isValidName(name)) {
		return;
	}
	cp.exec("rm -rf " + name);
}

module.exports.safe = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert Sink

	if (!isSafeName(name)) {
		return;
	}
	cp.exec("rm -rf " + name);
}

class Cla4 {
	wha(name) { // $ Source
		cp.exec("rm -rf " + name); // $ Alert Sink
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

module.exports.indirect = function (name) { // $ Source
	let cmd = "rm -rf " + name; // $ Alert Sink
	let sh = "sh";
	let args = ["-c", cmd];
	cp.spawn(sh, args, cb);
}

module.exports.indirect2 = function (name) { // $ Source
	let cmd = name;
	let sh = "sh";
	let args = ["-c", cmd];
	cp.spawn(sh, args, cb);

	let cmd2 = "rm -rf " + name; // $ Alert Sink
	var args2 = [cmd2];
	cp.spawn(
		'cmd.exe',
		['/C', editor].concat(args2),
		{ stdio: 'inherit' }
	);
}

module.exports.cmd = function (command, name) { // $ Source
	cp.exec("fo | " + command);

	cp.exec("fo | " + name); // $ Alert Sink

}

module.exports.sanitizer = function (name) { // $ Source
	var sanitized = "'" + name.replace(/'/g, "'\\''") + "'"
	cp.exec("rm -rf " + sanitized);

	var broken = "'" + name.replace(/'/g, "'\''") + "'" // $ Alert Sink
	cp.exec("rm -rf " + broken); // $ Alert Sink
}

var path = require("path");
module.exports.guard = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert Sink

	if (!path.exist(name)) {
		cp.exec("rm -rf " + name); // $ Alert Sink
		return;
	}
	cp.exec("rm -rf " + name);
}

module.exports.blacklistOfChars = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert Sink

	if (/[^A-Za-z0-9_\/:=-]/.test(name)) {
		cp.exec("rm -rf " + name); // $ Alert Sink
	} else {
		cp.exec("rm -rf " + name);
	}
}

module.exports.whitelistOfChars = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert Sink

	if (/^[A-Za-z0-9_\/:=-]$/.test(name)) {
		cp.exec("rm -rf " + name);
	} else {
		cp.exec("rm -rf " + name); // $ Alert Sink
	}
}

module.exports.blackList2 = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert Sink

	if (!/^([a-zA-Z0-9]+))?$/.test(name)) {
		cp.exec("rm -rf " + name); // $ Alert Sink
		process.exit(-1);
	}

	cp.exec("rm -rf " + name); // $ Sink SPURIOUS: Alert - FP due to tracking flow through `process.exit()`.
}

module.exports.accessSync = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert Sink

	try {
		path.accessSync(name);
	} catch (e) {
		return;
	}

	cp.exec("rm -rf " + name); // $ Sink SPURIOUS: Alert - FP due to `path.accessSync` not being recognized as a sanitizer.
}

var cleanInput = function (s) {
	if (/[^A-Za-z0-9_\/:=-]/.test(s)) {
		s = "'" + s.replace(/'/g, "'\\''") + "'";
		s = s.replace(/^(?:'')+/g, '') // unduplicate single-quote at the beginning
			.replace(/\\'''/g, "\\'"); // remove non-escaped single-quote if there are enclosed between 2 escaped
	}
	return s;
}

module.exports.goodSanitizer = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert Sink

	var cleaned = cleanInput(name);

	cp.exec("rm -rf " + cleaned); // $ Sink SPURIOUS: Alert - SanitizingRegExpTest is not able to generate a barrier edge for an edge into a phi node.
}

var fs = require("fs");
module.exports.guard2 = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert Sink

	if (!fs.existsSync("prefix/" + name)) {
		cp.exec("rm -rf prefix/" + name); // $ Alert Sink
		return;
	}
	cp.exec("rm -rf prefix/" + name);
}

module.exports.sanitizerProperty = function (obj) { // $ Source
	cp.exec("rm -rf " + obj.version); // $ Alert Sink

	obj.version = "";

	cp.exec("rm -rf " + obj.version);
}

module.exports.Foo = class Foo {
	start(opts) { // $ Source
		cp.exec("rm -rf " + opts.bla); // $ Alert Sink
		this.opts = {};
		this.opts.bla = opts.bla

		cp.exec("rm -rf " + this.opts.bla); // $ Alert Sink
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

module.exports.sanitizer2 = function (name) { // $ Source
  cp.exec("rm -rf " + name); // $ Alert Sink

  var sanitized = sanitizeShellString(name);
  cp.exec("rm -rf " + sanitized);
}

module.exports.typeofcheck = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert Sink
	
	if (typeof name === "undefined") {
		cp.exec("rm -rf " + name);
	} else {
		cp.exec("rm -rf " + name); // $ Alert Sink
	}
}

module.exports.typeofcheck = function (arg) { // $ Source
	var cmd = "MyWindowCommand | findstr /i /c:" + arg; // $ Alert Sink
	cp.exec(cmd); 
}

function id(x) {
	return x;
}

module.exports.id = id;

module.exports.unproblematic = function() {
	cp.exec("rm -rf " + id("test"));
};

module.exports.problematic = function(n) { // $ Source
	cp.exec("rm -rf " + id(n)); // $ Alert Sink
};

module.exports.typeofNumber = function(n) {
	if (typeof n === "number") {
		cp.exec("rm -rf " + n);
	}
};

function boundProblem(safe, unsafe) { // $ Source
	cp.exec("rm -rf " + safe);
	cp.exec("rm -rf " + unsafe); // $ Alert Sink
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
		var command = "learn " + this.learn_args + " " + model; // $ MISSING: Alert - lack of local field step
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

module.exports.sanitizer3 = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert Sink

	var sanitized = yetAnohterSanitizer(name);
	cp.exec("rm -rf " + sanitized);
}

const cp = require("child_process");
const spawn = cp.spawn;
module.exports.shellOption = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert Sink

	cp.execFile("rm", ["-rf", name], {shell: true}, (err, out) => {}); // $ Alert
	cp.spawn("rm", ["-rf", name], {shell: true}); // $ Alert
	cp.execFileSync("rm", ["-rf", name], {shell: true}); // $ Alert
	cp.spawnSync("rm", ["-rf", name], {shell: true}); // $ Alert

	const SPAWN_OPT = {shell: true};

	spawn("rm", ["first", name], SPAWN_OPT); // $ Alert
	var arr = [];
	arr.push(name); // $ Alert
	spawn("rm", arr, SPAWN_OPT); // $ Alert
	spawn("rm", build("node", (name ? name + ':' : '') + '-'), SPAWN_OPT); // $ Alert
}

function build(first, last) {
	var arr = [];
	if (something() === 'gm')
		arr.push('convert');
	first && arr.push(first);
	last && arr.push(last); // $ Alert
	return arr;
};

var asyncExec = require("async-execute");
module.exports.asyncStuff = function (name) { // $ Source
	asyncExec("rm -rf " + name); // $ Alert Sink
}

const myFuncs = {
	myFunc: function (name) { // $ Source
		asyncExec("rm -rf " + name); // $ Alert Sink
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

module.exports.check = function check(config) { // $ Source
    const cmd = path.join(config.installedPath, 'myBinary -v'); // $ Alert
    return exec(cmd);
}

module.exports.splitConcat = function (name) { // $ Source
	let args = ' my name is ' + name; // $ Alert Sink
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

	module.exports.myIndirectThing = function (name) { // $ Source
		MyThing.cp.exec("rm -rf " + name); // $ Alert Sink
	}
});
  

var imp = require('./isImported');
for (var name in imp){
  module.exports[name] = imp[name];
}

module.exports.sanitizer4 = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert Sink

	if (isNaN(name)) {
		cp.exec("rm -rf " + name); // $ Alert Sink
	} else {
		cp.exec("rm -rf " + name);
	}

	if (isNaN(parseInt(name))) {
		cp.exec("rm -rf " + name); // $ Alert Sink
	} else {
		cp.exec("rm -rf " + name);
	}

	if (isNaN(+name)) {
		cp.exec("rm -rf " + name); // $ Alert Sink
	} else {
		cp.exec("rm -rf " + name);
	}

	if (isNaN(parseInt(name, 10))) {
		cp.exec("rm -rf " + name); // $ Alert Sink
	} else {
		cp.exec("rm -rf " + name);
	}

	if (isNaN(name - 0)) {
		cp.exec("rm -rf " + name); // $ Alert Sink
	} else {
		cp.exec("rm -rf " + name);
	}

	if (isNaN(name | 0)) { // <- not a sanitizer
		cp.exec("rm -rf " + name); // $ Alert Sink
	} else {
		cp.exec("rm -rf " + name); // $ Alert Sink
	}
}


module.exports.shellThing = function (name) { // $ Source
    function indirectShell(cmd, args, spawnOpts) {
        cp.spawn(cmd, args, spawnOpts); // $ Alert
    }

    indirectShell("rm", ["-rf", name], {shell: true}); // $ Alert
}

module.exports.badSanitizer = function (name) { // $ Source
    if (!name.match(/^(.|\.){1,64}$/)) { // <- bad sanitizer
        exec("rm -rf " + name); // $ Alert Sink
    } else {
        exec("rm -rf " + name); // $ Alert Sink
    }

    if (!name.match(/^\w{1,64}$/)) { // <- good sanitizer
        exec("rm -rf " + name); // $ Alert Sink
    } else {
        exec("rm -rf " + name);
    }
}

module.exports.safeWithBool = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert Sink

	if (isSafeName(name)) {
		cp.exec("rm -rf " + name);
	}

    cp.exec("rm -rf " + name); // $ Alert Sink

    if (isSafeName(name) === true) {
        cp.exec("rm -rf " + name);
    }

    if (isSafeName(name) !== false) {
        cp.exec("rm -rf " + name);
    }

    if (isSafeName(name) == false) {
        cp.exec("rm -rf " + name); // $ Alert Sink
    }

    cp.exec("rm -rf " + name); // $ Alert Sink
}

function indirectThing(name) {
    return isSafeName(name);
}

function indirectThing2(name) {
    return isSafeName(name) === true;
}

function moreIndirect(name) {
    return indirectThing2(name) !== false;
}

module.exports.veryIndeirect = function (name) { // $ Source
	cp.exec("rm -rf " + name); // $ Alert Sink

	if (indirectThing(name)) {
        cp.exec("rm -rf " + name);
    }

    if (indirectThing2(name)) {
        cp.exec("rm -rf " + name);
    }

    if (moreIndirect(name)) {
        cp.exec("rm -rf " + name);
    }

    if (moreIndirect(name) !== false) {
        cp.exec("rm -rf " + name);
    } else {
        cp.exec("rm -rf " + name); // $ Alert Sink
    }

    cp.exec("rm -rf " + name); // $ Alert Sink
}

module.exports.sanitizer = function (name) { // $ Source
	var sanitized = "'" + name.replace(new RegExp("\'"), "'\\''") + "'" // $ Alert Sink
	cp.exec("rm -rf " + sanitized); // $ Alert Sink

	var sanitized = "'" + name.replace(new RegExp("\'", 'g'), "'\\''") + "'"
	cp.exec("rm -rf " + sanitized);

	var sanitized = "'" + name.replace(new RegExp("\'", unknownFlags()), "'\\''") + "'"
	cp.exec("rm -rf " + sanitized); // OK - Most likely should be okay and not flagged to reduce false positives.
}
