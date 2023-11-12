var cp = require("child_process"),
    shellQuote = require("shell-quote");

const args = process.argv.slice(2);
let nodeOpts = '';
if (args[0] === '--node-opts') {
    nodeOpts = args[1];
    args.splice(0, 2);
}
const script = path.join(__dirname, 'bin', 'main.js');
cp.execFileSync('node', shellQuote.parse(nodeOpts).concat(script).concat(args)); // GOOD
