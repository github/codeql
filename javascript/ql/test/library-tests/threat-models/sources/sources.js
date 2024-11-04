import 'dummy';

var x = process.env['foo']; // $ threat-source=environment
SINK(x); // $ hasFlow

var y = process.argv[2]; // $ threat-source=commandargs
SINK(y); // $ hasFlow


// Accessing command line arguments using yargs
// https://www.npmjs.com/package/yargs/v/17.7.2
const yargs = require('yargs/yargs');
const { hideBin } = require('yargs/helpers');
const argv = yargs(hideBin(process.argv)).argv; // $ threat-source=commandargs

SINK(argv.foo); // $ hasFlow

// older version
// https://www.npmjs.com/package/yargs/v/7.1.2
const yargsOld = require('yargs');
const argvOld = yargsOld.argv; // $ threat-source=commandargs

SINK(argvOld.foo); // $ hasFlow

// Accessing command line arguments using yargs-parser
const yargsParser = require('yargs-parser');
const src = process.argv.slice(2); // $ threat-source=commandargs
const parsedArgs = yargsParser(src);

SINK(parsedArgs.foo); // $ hasFlow

// Accessing command line arguments using minimist
const minimist = require('minimist');
const args = minimist(process.argv.slice(2)); // $ threat-source=commandargs

SINK(args.foo); // $ hasFlow


// Accessing command line arguments using commander
const { Command } = require('commander'); // $ SPURIOUS: threat-source=commandargs
const program = new Command();
program.parse(process.argv); // $ threat-source=commandargs

SINK(program.opts().foo); // $ hasFlow SPURIOUS: threat-source=commandargs

// ------ reading from database ------

// Accessing database using mysql
const mysql = require('mysql');
const connection = mysql.createConnection({host: 'localhost'});
connection.connect();
connection.query('SELECT 1 + 1 AS solution', function (error, results, fields) { // $ threat-source=database
    if (error) throw error;
    SINK(results); // $ hasFlow
    SINK(results[0]); // $ hasFlow
    SINK(results[0].solution); // $ hasFlow
});

// ------ reading from file ------

// Accessing file contents using fs
const fs = require('fs');
fs.readFile('file.txt', 'utf8', (err, data) => { // $ threat-source=file
  SINK(data); // $ hasFlow
});

// Accessing file contents using fs.readFileSync
const fileContent = fs.readFileSync('file.txt', 'utf8'); // $ threat-source=file
SINK(fileContent); // $ hasFlow

// Accessing file contents using fs.promises
fs.promises.readFile('file.txt', 'utf8').then((data) => { // $ threat-source=file
  SINK(data); // $ hasFlow
});

// Accessing file contents using fs.createReadStream
const readStream = fs.createReadStream('file.txt');
readStream.on('data', (chunk) => { // $ threat-source=file
  SINK(chunk); // $ hasFlow
});
const data = readStream.read(); // $ threat-source=file
SINK(data); // $ hasFlow

// using readline
const readline = require('readline');
const rl_file = readline.createInterface({
    input: fs.createReadStream('file.txt')
});
rl_file.on("line", (line) => { // $ SPURIOUS: threat-source=stdin MISSING: threat-source=file
    SINK(line); // $ hasFlow
});


// ------ reading from stdin ------

// Accessing stdin using process.stdin
process.stdin.on('data', (data) => { // $ threat-source=stdin
    SINK(data); // $ hasFlow
});

const stdin_line = process.stdin.read(); // $ threat-source=stdin
SINK(stdin_line); // $ hasFlow

// Accessing stdin using readline
const readline = require('readline');
const rl_stdin = readline.createInterface({
    input: process.stdin
});
rl_stdin.question('<question>', (answer) => { // $ threat-source=stdin
    SINK(answer); // $ hasFlow
});

function handler(answer) { // $ threat-source=stdin
    SINK(answer); // $ hasFlow
}
rl_stdin.question('<question>', handler);

rl_stdin.on("line", (line) => { // $ threat-source=stdin
    SINK(line); // $ hasFlow
});
