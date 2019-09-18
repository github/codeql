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
});
