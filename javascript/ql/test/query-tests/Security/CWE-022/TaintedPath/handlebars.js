const express = require('express');
const hb = require("handlebars");
const fs = require("fs");

const app = express();

const data = {};

function init() {
    hb.registerHelper("catFile", catFile);
    data.compiledFileAccess = hb.compile("contents of file {{path}} are: {{catFile path}}")
    data.compiledBenign = hb.compile("hello, {{name}}");
    data.compiledUnknown = hb.compile(fs.readFileSync("greeting.template"));
}

init();

app.get('/some/path1', function (req, res) {
    res.send(data.compiledFileAccess({ path: req.params.path })); // NOT ALLOWED (template uses vulnerable catFile)
});

function catFile(filePath) {
    return fs.readFileSync(filePath); // SINK (reads file)
}

app.get('/some/path2', function (req, res) {
    res.send(data.compiledBenign({ name: req.params.name })); // ALLOWED (this template does not use catFile)
});

app.get('/some/path3', function (req, res) { 
    res.send(data.compiledUnknown({ name: req.params.name })); // NOT ALLOWED (could be using vulnerable catFile)
});