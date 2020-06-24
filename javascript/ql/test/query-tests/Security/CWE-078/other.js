var http = require("http"),
    url = require("url");

var server = http.createServer(function(req, res) {
    let cmd = url.parse(req.url, true).query.path;

    require("cross-spawn").sync(cmd); // NOT OK
    require("execa").shell(cmd); // NOT OK
    require("execa").shellSync(cmd); // NOT OK
    require("execa").stdout(cmd); // NOT OK
    require("execa").stderr(cmd); // NOT OK
    require("execa").sync(cmd); // NOT OK

    require("cross-spawn")(cmd); // NOT OK
    require("cross-spawn-async")(cmd); // NOT OK
    require("exec")(cmd); // NOT OK
    require("exec-async")(cmd); // NOT OK
    require("execa")(cmd); // NOT OK
    require("remote-exec")(target, cmd); // NOT OK

    const ssh2 = require("ssh2");
    new ssh2().exec(cmd); // NOT OK
    new ssh2.Client().exec(cmd); // NOT OK

    const SSH2Stream = require("ssh2-streams").SSH2Stream;
    new SSH2Stream().exec(false, cmd); // NOT OK
});
