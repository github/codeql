const cp = require('child_process');

cp.execFile("node", ["--version"], cb);
cp.execFileSync("sh", ["-c", "node --version"]);
cp.fork("foo", ["arg"]);
cp.spawn("echo", ["Hi"], cb);
cp.spawnSync("echo", ["Hi", "there"]);
