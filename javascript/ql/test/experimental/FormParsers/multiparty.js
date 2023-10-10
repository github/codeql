var multiparty = require('multiparty');
var http = require('http');
var util = require('util');
const sink = require('sink');

http.createServer(function (req, res) {
    var form = new multiparty.Form();
    form.on('part', (part) => {
        sink(part)
        part.pipe(sink())
    });

    var form2 = new multiparty.Form();
    form2.parse(req, function (err, fields, files) {
        sink(fields, files)
    });
    form2.parse(req);

}).listen(8080);