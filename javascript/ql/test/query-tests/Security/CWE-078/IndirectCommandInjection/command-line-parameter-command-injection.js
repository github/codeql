var cp = require("child_process");

(function() {
	cp.exec(process.argv); // $ Alert - just weird
	cp.exec(process.argv[0]);
	cp.exec("cmd.sh " + process.argv[0]);
	cp.exec("cmd.sh " + process.argv[1]);
	cp.exec("cmd.sh " + process.argv[2]); // $ Alert

	var args = process.argv.slice(2); // $ Source
	cp.execSync(args[0]); // $ Alert
	cp.execSync("cmd.sh " + args[0]); // $ Alert

	var fewerArgs = args.slice(1);
	cp.execSync(fewerArgs[0]); // $ Alert
	cp.execSync("cmd.sh " + fewerArgs[0]); // $ Alert

	var arg0 = fewerArgs[0];
	cp.execSync(arg0); // $ Alert
	cp.execSync("cmd.sh " + arg0); // $ Alert
});

(function() {
	const args = process.argv.slice(2); // $ Source
	const script = path.join(packageDir, 'app', 'index.js');
	cp.execSync(`node ${script} ${args[0]} --option"`); // $ Alert
	cp.execSync(`node ${script} ${args.join(' ')} --option"`); // $ Alert
});

cp.exec("cmd.sh " + require("get-them-args")().foo); // $ Alert
cp.exec("cmd.sh " + require("minimist")().foo); // OK - no args provided.
cp.exec("cmd.sh " + require("yargs").argv.foo); // $ Alert
cp.exec("cmd.sh " + require("optimist").argv.foo); // $ Alert

(function () {
	var args = require('yargs') // eslint-disable-line
		.command('serve [port]', 'start the server', (yargs) => { })
		.option('verbose', { foo: "bar" })
		.argv // $ Source

	cp.exec("cmd.sh " + args); // $ Alert

	cp.exec("cmd.sh " + require("yargs").array("foo").parse().foo); // $ Alert
});

(function () {
	const {
		argv: {
			...args
		}, // $ Source
	} = require('yargs')
		.usage('Usage: foo bar')
		.command();

	cp.exec("cmd.sh " + args); // $ Alert

	var tainted1 = require('yargs').argv; // $ Source
	var tainted2 = require('yargs').parse() // $ Source
	
	const {taint1: {...taint1rest},taint2: {...taint2rest}} = {
		taint1: tainted1,
		taint2: tainted2
	}

	cp.exec("cmd.sh " + taint1rest); // $ Alert - has flow from tainted1
	cp.exec("cmd.sh " + taint2rest); // $ Alert - has flow from tianted2
	
	var {...taint3} = require('yargs').argv; // $ Source
	cp.exec("cmd.sh " + taint3); // $ Alert

	var [...taint4] = require('yargs').argv; // $ Source
	cp.exec("cmd.sh " + taint4); // $ Alert
});

(function () {
	const argv = process.argv.slice(2); // $ Source

	var minimist = require("minimist");
	cp.exec("cmd.sh " + minimist(argv).foo); // $ Alert

	var subarg = require('subarg');
	cp.exec("cmd.sh " + subarg(process.argv.slice(2)).foo); // $ Alert

	var yargsParser = require('yargs-parser');
	cp.exec("cmd.sh " + yargsParser(process.argv.slice(2)).foo); // $ Alert

	import args from 'args'
	var flags = args.parse(process.argv); // $ Source
	cp.exec("cmd.sh " + flags.foo); // $ Alert

	var flags = require('arg')({...spec}); // $ Source
	cp.exec("cmd.sh " + flags.foo); // $ Alert
})

(function () {
	const { ArgumentParser } = require('argparse');
	
	const parser = new ArgumentParser({description: 'Argparse example'});
	
	parser.add_argument('-f', '--foo', { help: 'foo bar' });
	
	cp.exec("cmd.sh " + parser.parse_args().foo); // $ Alert
});

(function () {
	const commandLineArgs = require('command-line-args');
	const options = commandLineArgs(optionDefinitions); // $ Source
	cp.exec("cmd.sh " + options.foo); // $ Alert
});

(function () {
	const meow = require('meow');
	 
	const cli = meow(`helpstring`, {flags: {...flags}}); // $ Source

	cp.exec("cmd.sh " + cli.input[0]); // $ Alert
});

(function () {
	var dashdash = require('dashdash');
 
	var opts = dashdash.parse({options: options}); // $ Source
	
	cp.exec("cmd.sh " + opts.foo); // $ Alert

	var parser = dashdash.createParser({options: options});
	var opts = parser.parse(); // $ Source
	
	cp.exec("cmd.sh " + opts.foo); // $ Alert
});

(function () {
	const { program } = require('commander'); // $ Source
	program.version('0.0.1');

	cp.exec("cmd.sh " + program.opts().pizzaType); // $ Alert
	cp.exec("cmd.sh " + program.pizzaType); // $ Alert
});

(function () {
	const { Command } = require('commander');
	const program = new Command();
	program.version('0.0.1');

	cp.exec("cmd.sh " + program.opts().pizzaType); // $ Alert
	cp.exec("cmd.sh " + program.pizzaType); // $ Alert

	cp.execFile(program.opts().pizzaType, ["foo", "bar"]);
});