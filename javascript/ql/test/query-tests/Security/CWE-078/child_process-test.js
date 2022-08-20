var cp = require("child_process"),
    http = require('http'),
    url = require('url');

var server = http.createServer(function(req, res) {
    let cmd = url.parse(req.url, true).query.path;

    cp.exec("foo"); // OK
    cp.execSync("foo"); // OK
    cp.execFile("foo"); // OK
    cp.execFileSync("foo"); // OK
    cp.spawn("foo"); // OK
    cp.spawnSync("foo"); // OK
    cp.fork("foo"); // OK


    cp.exec(cmd); // NOT OK
    cp.execSync(cmd); // NOT OK
    cp.execFile(cmd); // NOT OK
    cp.execFileSync(cmd); // NOT OK
    cp.spawn(cmd); // NOT OK
    cp.spawnSync(cmd); // NOT OK
    cp.fork(cmd); // NOT OK

    cp.exec("foo" + cmd + "bar"); // NOT OK

    // These are technically NOT OK, but they are more likely as false positives
    cp.exec("foo", {shell: cmd}); // OK
    cp.exec("foo", {env: {PATH: cmd}}); // OK
    cp.exec("foo", {cwd: cmd}); // OK
    cp.exec("foo", {uid: cmd}); // OK
    cp.exec("foo", {gid: cmd}); // OK

    let sh, flag;
    if (process.platform == 'win32')
      sh = 'cmd.exe', flag = '/c';
    else
      sh = '/bin/sh', flag = '-c';
    cp.spawn(sh, [ flag, cmd ]); // NOT OK

    let args = [];
    args[0] = "-c";
    args[1] = cmd;  // NOT OK
    cp.execFile("/bin/bash", args);

    let args = [];
    args[0] = "-c";
    args[1] = cmd;  // NOT OK
    run("sh", args);

    let args = [];
    args[0] = `-` + "c";
    args[1] = cmd; // NOT OK
    cp.execFile(`/bin` + "/bash", args);

    cp.spawn('cmd.exe', ['/C', 'foo'].concat(["bar", cmd])); // NOT OK
    cp.spawn('cmd.exe', ['/C', 'foo'].concat(cmd)); // NOT OK

	let myArgs = [];
    myArgs.push(`-` + "c");
    myArgs.push(cmd);
    cp.execFile(`/bin` + "/bash", args); // NOT OK - but no support for `[].push()` for indirect arguments [INCONSISTENCY] 

});

function run(cmd, args) {
  cp.spawn(cmd, args); // OK - the alert happens where `args` is build.
}

var util = require("util")

http.createServer(function(req, res) {
    let cmd = url.parse(req.url, true).query.path;

    util.promisify(cp.exec)(cmd); // NOT OK
});


const webpackDevServer = require('webpack-dev-server');
new webpackDevServer(compiler, {
    before: function (app) {
        app.use(function (req, res, next) {
          cp.exec(req.query.fileName); // NOT OK

          require("my-sub-lib").foo(req.query.fileName); // calls lib/subLib/index.js#foo
        });
    }
});

import Router from "koa-router";
const router = new Router();

router.get("/ping/:host", async (ctx) => {
  cp.exec("ping " + ctx.params.host); // NOT OK
});