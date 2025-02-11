var cp = require("child_process"),
    http = require('http'),
    url = require('url');

var server = http.createServer(function(req, res) {
    let cmd = url.parse(req.url, true).query.path;

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
    args[1] = cmd;
    cp.execFile("/bin/bash", args); // $ Alert

    let args = [];
    args[0] = "-c";
    args[1] = cmd;
    run("sh", args);

    let args = [];
    args[0] = `-` + "c";
    args[1] = cmd;
    cp.execFile(`/bin` + "/bash", args); // $ Alert

    cp.spawn('cmd.exe', ['/C', 'foo'].concat(["bar", cmd])); // $ Alert
    cp.spawn('cmd.exe', ['/C', 'foo'].concat(cmd)); // $ Alert

	let myArgs = [];
    myArgs.push(`-` + "c");
    myArgs.push(cmd);
    cp.execFile(`/bin` + "/bash", args); // $ MISSING: Alert - no support for `[].push()` for indirect arguments

});

function run(cmd, args) {
  cp.spawn(cmd, args); // $ Alert - but note that the sink is where `args` is build.
}

var util = require("util")

http.createServer(function(req, res) {
    let cmd = url.parse(req.url, true).query.path;

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
