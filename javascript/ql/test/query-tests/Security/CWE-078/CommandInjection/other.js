var http = require("http"),
    url = require("url");

var server = http.createServer(function (req, res) {
    let cmd = url.parse(req.url, true).query.path; // $ Source

    require("cross-spawn").sync(cmd); // $ Alert
    require("execa").shell(cmd); // $ Alert
    require("execa").shellSync(cmd); // $ Alert
    require("execa").stdout(cmd); // $ Alert
    require("execa").stderr(cmd); // $ Alert
    require("execa").sync(cmd); // $ Alert

    require("cross-spawn")(cmd); // $ Alert
    require("cross-spawn-async")(cmd); // $ Alert
    require("exec")(cmd); // $ Alert
    require("exec-async")(cmd); // $ Alert
    require("execa")(cmd); // $ Alert
    require("remote-exec")(target, cmd); // $ Alert

    const ssh2 = require("ssh2");
    new ssh2().exec(cmd); // $ Alert
    new ssh2.Client().exec(cmd); // $ Alert

    const SSH2Stream = require("ssh2-streams").SSH2Stream;
    new SSH2Stream().exec(false, cmd); // $ Alert

    require("execa").node(cmd); // $ Alert

    require("foreground-child")(cmd); // $ Alert

    const opener = require("opener");
    opener("http://github.com/" + url.parse(req.url, true).query.user);
    opener("http://github.com", { command: cmd }); // $ Alert
});
