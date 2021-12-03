const cp = require('child_process'),
    http = require('http'),
    url = require('url');

function getShell() {
    if (process.platform === 'win32') {
        return { cmd: 'cmd', arg: '/C' }
    } else {
        return { cmd: 'sh', arg: '-c' }
    }
}

function execSh(command, options) {
    var shell = getShell()
    return cp.spawn(shell.cmd, [shell.arg, command], options) // BAD
}

http.createServer(function (req, res) {
    let cmd = url.parse(req.url, true).query.path;
    execSh(cmd);
});
