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
	cp.execSync(arg0); // OK
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
