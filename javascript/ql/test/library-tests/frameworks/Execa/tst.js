import { execa, execaSync, execaCommand, execaCommandSync, execaNode, $ } from 'execa';

// Node.js scripts
await $`echo example1`.pipeStderr(`tmp`);
await $`echo ${"example2"}`.pipeStderr(`tmp`);
$.sync`echo example2 sync`
// Multiple arguments
const args = ["arg:" + arg, 'example3', '&', 'rainbows!'];
// GOOD
await $`${arg} sth`;
// GOOD only one command can be executed
await $`${arg}`;
$.sync`${arg}`
// BAD argument injection
$.sync`echo ${args} ${args}`
await $`echo ${["-a", "-lps"]}`
// if shell: true then all inputs except first are dangerous
await $({ shell: true })`echo example6 ${";echo example6 > tmpdir/example6"}`
// GOOD
await $({ shell: false })`echo example6 ${";echo example6 > tmpdir/example6"}`

// execa
// GOOD
await execa('aCommand', ['example1']);
// BAD argument injection
await execa('echo', ['example1']);
// BAD shell is enable
await execa('echo example 10 ; echo example 11', { shell: true });
await execa('echo example 10', ['; echo example 11'], { shell: true });

// BAD argument injection
execaSync('echo', ['example5 sync']);
// BAD argument injection
await execaCommand("echo " + "badArgument");
await execaCommand(`echo ${"arg1"} execaCommandSync`);
// bad totally controllable argument
execaCommandSync(arg);
// BAD shell is enable
execaCommandSync("echo 1 " + "; echo 2", { shell: true });

// FileSystemAccess
// Piping stdout to a file
await $`echo example8`.pipeStdout('tmp')
// Piping stdin from a file
await $({ inputFile: 'sink' })`cat`
await execa('cat', { inputFile: 'sink' });
await execa('echo', ['example2']).pipeStdout('tmpdir/sink.txt');
await execa('echo', ['example3']).pipeStderr('tmpdir/sink.txt');
await execa('echo', ['example4'], { all: true }).pipeAll('tmpdir/sink.txt');
