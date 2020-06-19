
var express = require('express');
var path = require("path");

var app = express();

// Not good. 
app.use(express.static('./node_modules/angular'));
app.use('/angular', express.static('node_modules/angular'));
app.use('/animate', express.static('node_modules/angular-animate'));
app.use('/js', express.static(__dirname + '/node_modules/angular'));
app.use('/router', express.static(__dirname + '/node_modules/angular-route/'));
app.use(express.static('/node_modules/angular'));
app.use('/node_modules', express.static(path.resolve(__dirname, '../node_modules')));
app.use('/js',express.static('./'));
app.use('/angular', express.static("./node_modules" + '/angular/'));
app.use('/angular', express.static(path.join("./node_modules" + '/angular/')));
app.use('/angular', express.static(path.join(__dirname, "/node_modules")));
app.use('/angular', express.static(path.join(__dirname, "/node_modules") + '/angular/'));
const rootDir = __dirname;
const nodeDir = path.join(rootDir + "/node_modules");
app.use('/angular', express.static(nodeDir + '/angular/'));


// Good
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
app.use('basedir', express.static(__dirname)); // GOOD, because there is no package.json in the same folder.
app.use('/monthly', express.static(__dirname + '/')); // GOOD, because there is no package.json in the same folder.

const connect = require("connect");
app.use('/angular', connect.static(path.join(__dirname, "/node_modules") + '/angular/')); // NOT OK
app.use('/angular', require('serve-static')(path.join(__dirname, "/node_modules") + '/angular/')); // NOT OK
app.use('/home', require('serve-static')(require("os").homedir())); // NOT OK
app.use('/root', require('serve-static')("/")); // NOT OK

// Bad documentation example
function bad() {
    var express = require('express');

    var app = express();

    app.use('/node_modules', express.static(path.resolve(__dirname, '../node_modules'))); // NOT OK
}

// Good documentation example
function good() {
    var express = require('express');

    var app = express();

    app.use("jquery", express.static('./node_modules/jquery/dist')); // OK
    app.use("bootstrap", express.static('./node_modules/bootstrap/dist')); // OK
}