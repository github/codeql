const cp = require('child_process');

cp.execFile("node", ["--version"], cb);
cp.execFileSync("sh", ["-c", "node --version"]);
cp.fork("foo", ["arg"]);
cp.spawn("echo", ["Hi"], cb);
cp.spawnSync("echo", ["Hi", "there"]);

cp.spawn("echo", { shell: true });
cp.spawn("echo", ["Hi"], { shell: true });
cp.execFile("echo", { shell: "/bin/sh" });
cp.execFile("echo", ["Hi"], { shell: "/bin/sh" });

function overloads(args, callback) {
    cp.exec("echo", callback);
    cp.execFile("echo", args, callback);
    cp.spawn("echo", args, { shell: true });
    cp.execFile("echo", args, { shell: "/bin/sh" });
    cp.execFile("echo", args, { shell: true }, callback);
    cp.execFile("echo", { shell: true }, callback);
}
