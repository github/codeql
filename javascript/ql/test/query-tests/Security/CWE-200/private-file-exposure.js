
var express = require('express');
var path = require("path");

var app = express();

// Not good. 
app.use(express.static('./node_modules/angular')); // $ TODO-SPURIOUS: Alert[js/exposure-of-private-files]
app.use('/angular', express.static('node_modules/angular')); // $ TODO-SPURIOUS: Alert[js/exposure-of-private-files]
app.use('/animate', express.static('node_modules/angular-animate')); // $ TODO-SPURIOUS: Alert[js/exposure-of-private-files]
app.use('/js', express.static(__dirname + '/node_modules/angular')); // $ TODO-SPURIOUS: Alert[js/exposure-of-private-files]
app.use('/router', express.static(__dirname + '/node_modules/angular-route/')); // $ TODO-SPURIOUS: Alert[js/exposure-of-private-files]
app.use(express.static('/node_modules/angular')); // $ TODO-SPURIOUS: Alert[js/exposure-of-private-files]
app.use('/node_modules', express.static(path.resolve(__dirname, '../node_modules'))); // $ TODO-SPURIOUS: Alert[js/exposure-of-private-files]
app.use('/js',express.static('./')); // $ TODO-SPURIOUS: Alert[js/exposure-of-private-files]
app.use('/angular', express.static("./node_modules" + '/angular/')); // $ TODO-SPURIOUS: Alert[js/exposure-of-private-files]
app.use('/angular', express.static(path.join("./node_modules" + '/angular/'))); // $ TODO-SPURIOUS: Alert[js/exposure-of-private-files]
app.use('/angular', express.static(path.join(__dirname, "/node_modules"))); // $ TODO-SPURIOUS: Alert[js/exposure-of-private-files]
app.use('/angular', express.static(path.join(__dirname, "/node_modules") + '/angular/')); // $ TODO-SPURIOUS: Alert[js/exposure-of-private-files]
const rootDir = __dirname;
const nodeDir = path.join(rootDir + "/node_modules");
app.use('/angular', express.static(nodeDir + '/angular/')); // $ TODO-SPURIOUS: Alert[js/exposure-of-private-files]



app.use(express.static('./node_modules/jquery/dist'));
app.use(express.static('./node_modules/bootstrap/dist'));
app.use('/js', express.static(__dirname + '/node_modules/html5sortable/dist'));
app.use('/css', express.static(__dirname + '/css'));
app.use('/favicon.ico', express.static(__dirname + '/favicon.ico'));
app.use(express.static(__dirname + "/static"));
app.use(express.static(__dirname + "/static/js"));
app.use('/docs/api', express.static('docs/api'));
app.use('/js/', express.static('node_modules/bootstrap/dist/js'))
app.use('/css/', express.static('node_modules/font-awesome/css'));
app.use('basedir', express.static(__dirname)); // OK - because there is no package.json in the same folder.
app.use('/monthly', express.static(__dirname + '/')); // OK - because there is no package.json in the same folder.

const connect = require("connect");
app.use('/angular', connect.static(path.join(__dirname, "/node_modules") + '/angular/')); // $ Alert TODO-MISSING: Alert[js/file-access-to-http]
app.use('/angular', require('serve-static')(path.join(__dirname, "/node_modules") + '/angular/')); // $ Alert TODO-MISSING: Alert[js/file-access-to-http]
app.use('/home', require('serve-static')(require("os").homedir())); // $ Alert TODO-MISSING: Alert[js/file-access-to-http]
app.use('/root', require('serve-static')("/")); // $ Alert TODO-MISSING: Alert[js/file-access-to-http]

// Bad documentation example
function bad() {
    var express = require('express');

    var app = express();

    app.use('/node_modules', express.static(path.resolve(__dirname, '../node_modules'))); // $ Alert TODO-MISSING: Alert[js/file-access-to-http]
}

// Good documentation example
function good() {
    var express = require('express');

    var app = express();

    app.use("jquery", express.static('./node_modules/jquery/dist'));
    app.use("bootstrap", express.static('./node_modules/bootstrap/dist'));
}

app.use(express.static(__dirname)) // $ Alert TODO-MISSING: Alert[js/exposure-of-private-files] Alert[js/file-access-to-http]

const serveHandler = require("serve-handler");
const http = require("http");

http.createServer((request, response) => {
    serveHandler(request, response, {public: "./node_modules/angular"}); // $ Alert TODO-MISSING: Alert[js/file-access-to-http]

    serveHandler(request, response);
}).listen(8080);