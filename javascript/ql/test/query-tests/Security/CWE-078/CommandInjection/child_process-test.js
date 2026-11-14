var cp = require("child_process"),
    http = require('http'),
    url = require('url');

var server = http.createServer(function(req, res) {
    let cmd = url.parse(req.url, true).query.path; // $ Sink Source

    cp.exec("foo");
    cp.execSync("foo");
    cp.execFile("foo");
    cp.execFileSync("foo");
    cp.spawn("foo");
    cp.spawnSync("foo");
    cp.fork("foo");


    cp.exec(cmd); // $ Alert
    cp.execSync(cmd); // $ Alert
    cp.execFile(cmd); // $ Alert
    cp.execFileSync(cmd); // $ Alert
    cp.spawn(cmd); // $ Alert
    cp.spawnSync(cmd); // $ Alert
    cp.fork(cmd); // $ Alert

    cp.exec("foo" + cmd + "bar"); // $ Alert

    // These are technically NOT OK, but they are more likely as false positives
    cp.exec("foo", {shell: cmd});
    cp.exec("foo", {env: {PATH: cmd}});
    cp.exec("foo", {cwd: cmd});
    cp.exec("foo", {uid: cmd});
    cp.exec("foo", {gid: cmd});

    let sh, flag;
    if (process.platform == 'win32')
      sh = 'cmd.exe', flag = '/c';
    else
      sh = '/bin/sh', flag = '-c';
    cp.spawn(sh, [ flag, cmd ]); // $ Alert

    let args = [];
    args[0] = "-c";
    args[1] = cmd; // $ Sink
    cp.execFile("/bin/bash", args); // $ Alert

    args = [];
    args[0] = "-c";
    args[1] = cmd; // $ Sink
    run("sh", args);

    args = [];
    args[0] = `-` + "c";
    args[1] = cmd; // $ Sink
    cp.execFile(`/bin` + "/bash", args); // $ Alert

    cp.spawn('cmd.exe', ['/C', 'foo'].concat(["bar", cmd])); // $ Alert
    cp.spawn('cmd.exe', ['/C', 'foo'].concat(cmd)); // $ Alert

    let myArgs = [];
    myArgs.push(`-` + "c");
    myArgs.push(cmd);
    cp.execFile(`/bin` + "/bash", myArgs); // $ MISSING: Alert - no support for `[].push()` for indirect arguments

});

function run(cmd, args) { // $ Sink
  cp.spawn(cmd, args); // $ Alert - but note that the sink is where `args` is build.
}

var util = require("util")

http.createServer(function(req, res) {
    let cmd = url.parse(req.url, true).query.path; // $ Source

    util.promisify(cp.exec)(cmd); // $ Alert
});


const webpackDevServer = require('webpack-dev-server');
new webpackDevServer(compiler, {
    before: function (app) {
        app.use(function (req, res, next) {
          cp.exec(req.query.fileName); // $ Alert

          require("my-sub-lib").foo(req.query.fileName); // calls lib/subLib/index.js#foo
        });
    }
});

import Router from "koa-router";
const router = new Router();

router.get("/ping/:host", async (ctx) => {
  cp.exec("ping " + ctx.params.host); // $ Alert
});

http.createServer(function(req, res) {
    const name = url.parse(req.url, true).query.name; // $ Source

    cp.spawn("echo", ["hello", name], { shell: true }); // $ Alert
    cp.spawn("echo", ["hello", name], { shell: "/bin/sh" }); // $ Alert
    cp.spawnSync("echo", ["hello", name], { shell: true }); // $ Alert
    cp.spawnSync("echo", ["hello", name], { shell: "/bin/sh" }); // $ Alert
    cp.execFile("echo", ["hello", name], { shell: true }); // $ Alert
    cp.execFile("echo", ["hello", name], { shell: "/bin/sh" }); // $ Alert
    cp.execFile("echo", ["hello", name], { shell: true }, () => {}); // $ Alert
    cp.execFile("echo", ["hello", name], { shell: "/bin/sh" }, () => {}); // $ Alert
    cp.execFileSync("echo", ["hello", name], { shell: true }); // $ Alert
    cp.execFileSync("echo", ["hello", name], { shell: "/bin/sh" }); // $ Alert
    util.promisify(cp.execFile)("echo", ["hello", name], { shell: true }); // $ Alert
    util.promisify(cp.execFile)("echo", ["hello", name], { shell: "/bin/sh" }); // $ Alert

    const shell = "/bin/sh";
    const options = { shell };
    const args = ["hello", name];
    cp.spawn("echo", args, options); // $ Alert
    cp.execFile("echo", args, options); // $ Alert


    const arrayWithProperty = [name];
    arrayWithProperty.shell = false;
    cp.spawn("echo", arrayWithProperty, { shell: true }); // $ Alert

    const pushed = [];
    pushed.push(name);
    cp.spawn("echo", pushed, { shell: true }); // $ Alert
    const shifted = [];
    shifted.unshift(name);
    cp.execFile("echo", shifted, { shell: "/bin/sh" }); // $ Alert

    cp.spawn("echo", [name]);
    cp.spawn("echo", [name], { shell: false });
    cp.spawn("echo", [name], { shell: "" });
    cp.spawnSync("echo", [name]);
    cp.spawnSync("echo", [name], { shell: false });
    cp.spawnSync("echo", [name], { shell: "" });
    cp.execFile("echo", [name]);
    cp.execFile("echo", [name], { shell: false });
    cp.execFile("echo", [name], { shell: "" });
    cp.execFileSync("echo", [name]);
    cp.execFileSync("echo", [name], { shell: false });
    cp.execFileSync("echo", [name], { shell: "" });
    cp.spawn("echo", ["hello"], { shell: true });
    cp.execFile("echo", ["hello"], { shell: "/bin/sh" });

    const laterPush = [];
    cp.spawn("echo", laterPush, { shell: true });
    laterPush.push(name);
    const laterUnshift = [];
    cp.execFile("echo", laterUnshift, { shell: "/bin/sh" });
    laterUnshift.unshift(name);

    const disabled = { shell: "/bin/sh" };
    disabled.shell = false;
    cp.spawn("echo", [name], disabled);
    const empty = { shell: true };
    empty.shell = "";
    cp.execFile("echo", [name], empty);
    const enabled = { shell: false };
    enabled.shell = "/bin/sh";
    cp.spawn("echo", [name], enabled); // $ Alert
    const alias = enabled;
    alias.shell = false;
    cp.execFile("echo", [name], enabled);
    const changedAfterCall = { shell: false };
    cp.spawn("echo", [name], changedAfterCall);
    changedAfterCall.shell = true;

    const conditional = { shell: "/bin/sh" };
    if (process.env.DISABLE_SHELL) conditional.shell = false;
    cp.spawn("echo", [name], conditional); // $ Alert


    const disabledOnBothBranches = { shell: true };
    if (process.env.DISABLE_SHELL) disabledOnBothBranches.shell = false;
    else disabledOnBothBranches.shell = "";
    cp.spawn("echo", [name], disabledOnBothBranches);

    const disabledAfterCall = { shell: true };
    cp.spawn("echo", [name], disabledAfterCall); // $ Alert
    disabledAfterCall.shell = false;

    function runWithArgs(args) {
        cp.spawn("echo", args, { shell: true }); // $ Alert
        cp.execFile("echo", args, { shell: "/bin/sh" }); // $ Alert
    }
    runWithArgs([name]);

    function runWithOptions(options) {
        if (process.env.DISABLE_SHELL) options.shell = false;
        cp.spawn("echo", [name], options); // $ Alert
    }
    runWithOptions({ shell: true });
});

http.createServer(function(req, res) {
    const options = req.body;
    options.shell = true;
    cp.spawn("echo", options);
    cp.spawnSync("echo", options);
    cp.execFile("echo", options);
    cp.execFile("echo", options, () => {});
    cp.execFileSync("echo", options);
});
