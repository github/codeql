const cp = require('child_process'),
    http = require('http'),
    url = require('url');

function getShell() {
    return "sh";
}

function execSh(command, options) {
    return cp.spawn(getShell(), ["-c", command], options) // BAD
};

http.createServer(function (req, res) {
    let cmd = url.parse(req.url, true).query.path;
    execSh(cmd);
});
