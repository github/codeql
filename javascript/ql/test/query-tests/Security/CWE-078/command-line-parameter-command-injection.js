var cp = require("child_process");

(function() {
	cp.exec(process.argv); // NOT OK (just weird)
	cp.exec(process.argv[0]); // OK
	cp.exec("cmd.sh " + process.argv[0]); // OK
	cp.exec("cmd.sh " + process.argv[1]); // OK
	cp.exec("cmd.sh " + process.argv[2]); // NOT OK

	var args = process.argv.slice(2);
	cp.execSync(args[0]); // NOT OK
	cp.execSync("cmd.sh " + args[0]); // NOT OK

	var fewerArgs = args.slice(1);
	cp.execSync(fewerArgs[0]); // NOT OK
	cp.execSync("cmd.sh " + fewerArgs[0]); // NOT OK

	var arg0 = fewerArgs[0];
	cp.execSync(arg0); // NOT OK
	cp.execSync("cmd.sh " + arg0); // NOT OK
});

(function() {
	const args = process.argv.slice(2);
	const script = path.join(packageDir, 'app', 'index.js');
	cp.execSync(`node ${script} ${args[0]} --option"`); // NOT OK
	cp.execSync(`node ${script} ${args.join(' ')} --option"`); // NOT OK
});

cp.exec("cmd.sh " + require("get-them-args")().foo); // NOT OK
cp.exec("cmd.sh " + require("minimist")().foo); // NOT OK
cp.exec("cmd.sh " + require("yargs").argv.foo); // NOT OK
cp.exec("cmd.sh " + require("optimist").argv.foo); // NOT OK

(function () {
	var args = require('yargs') // eslint-disable-line
		.command('serve [port]', 'start the server', (yargs) => { })
		.option('verbose', { foo: "bar" })
		.argv

	cp.exec("cmd.sh " + args); // NOT OK

	cp.exec("cmd.sh " + require("yargs").array("foo").parse().foo); // NOT OK
});

(function () {
	const {
		argv: {
			...args
		},
	} = require('yargs')
		.usage('Usage: foo bar')
		.command();

	cp.exec("cmd.sh " + args); // NOT OK

	var tainted1 = require('yargs').argv;
	var tainted2 = require('yargs').parse()
	
	const {taint1: {...taint1rest},taint2: {...taint2rest}} = {
		taint1: tainted1,
		taint2: tainted2
	}

	cp.exec("cmd.sh " + taint1rest); // NOT OK - has flow from tainted1
	cp.exec("cmd.sh " + taint2rest); // NOT OK - has flow from tianted2
	
	var {...taint3} = require('yargs').argv;
	cp.exec("cmd.sh " + taint3); // NOT OK

	var [...taint4] = require('yargs').argv;
	cp.exec("cmd.sh " + taint4); // NOT OK
});

