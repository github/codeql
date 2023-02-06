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
cp.exec("cmd.sh " + require("minimist")().foo); // OK - no args provided.
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

(function () {
	const argv = process.argv.slice(2);

	var minimist = require("minimist");
	cp.exec("cmd.sh " + minimist(argv).foo); // NOT OK

	var subarg = require('subarg');
	cp.exec("cmd.sh " + subarg(process.argv.slice(2)).foo); // NOT OK

	var yargsParser = require('yargs-parser');
	cp.exec("cmd.sh " + yargsParser(process.argv.slice(2)).foo); // NOT OK

	import args from 'args'
	var flags = args.parse(process.argv);
	cp.exec("cmd.sh " + flags.foo); // NOT OK

	var flags = require('arg')({...spec});
	cp.exec("cmd.sh " + flags.foo); // NOT OK
})

(function () {
	const { ArgumentParser } = require('argparse');
	
	const parser = new ArgumentParser({description: 'Argparse example'});
	
	parser.add_argument('-f', '--foo', { help: 'foo bar' });
	
	cp.exec("cmd.sh " + parser.parse_args().foo); // NOT OK
});

(function () {
	const commandLineArgs = require('command-line-args');
	const options = commandLineArgs(optionDefinitions);
	cp.exec("cmd.sh " + options.foo); // NOT OK
});

(function () {
	const meow = require('meow');
	 
	const cli = meow(`helpstring`, {flags: {...flags}});

	cp.exec("cmd.sh " + cli.input[0]); // NOT OK
});

(function () {
	var dashdash = require('dashdash');
 
	var opts = dashdash.parse({options: options});
	
	cp.exec("cmd.sh " + opts.foo); // NOT OK

	var parser = dashdash.createParser({options: options});
	var opts = parser.parse();
	
	cp.exec("cmd.sh " + opts.foo); // NOT OK
});

(function () {
	const { program } = require('commander');
	program.version('0.0.1');

	cp.exec("cmd.sh " + program.opts().pizzaType); // NOT OK
	cp.exec("cmd.sh " + program.pizzaType); // NOT OK
});

(function () {
	const { Command } = require('commander');
	const program = new Command();
	program.version('0.0.1');

	cp.exec("cmd.sh " + program.opts().pizzaType); // NOT OK
	cp.exec("cmd.sh " + program.pizzaType); // NOT OK
});