var http =require('http'),
    url = require('url');

var server = http.createServer(function(req, res) {
    let cmd = url.parse(req.url, true).query.path;

    var exec = require('exec');

    exec('foo'); // OK
    require('exec')('foo'); // OK
    require('exec-async').someFunction('foo'); // OK
    require('spawn-async').someFunction('foo'); // OK
    require('shelljs').someFunction('foo'); // OK
    require('remote-exec').someFunction('foo'); // OK
    require('cross-spawn').someFunction('foo'); // OK


    // NB :: we do not identify the following as sinks yet!
    exec(cmd); // OK (for now)
    require('exec')(cmd); // OK (for now)
    require('exec-async').someFunction(cmd); // OK (for now)
    require('spawn-async').someFunction(cmd); // OK (for now)
    require('shelljs').someFunction(cmd); // OK (for now)
    require('remote-exec').someFunction(cmd); // OK (for now)
    require('cross-spawn').someFunction(cmd); // OK (for now)
});
