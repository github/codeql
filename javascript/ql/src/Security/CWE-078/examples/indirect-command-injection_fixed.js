var cp = require("child_process");

const args = process.argv.slice(2);
const script = path.join(__dirname, 'bin', 'main.js');
cp.execFileSync('node', [script].concat(args)); // GOOD
