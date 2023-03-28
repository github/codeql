const express = require('express');
const hb = require("handlebars");
const fs = require("fs");

const app = express();

const data = {};

function init() {
    hb.registerHelper("catFile", function catFile(filePath) {
        return fs.readFileSync(filePath); // SINK (reads file)
    });
    hb.registerHelper("prependToLines", function prependToLines(prefix, filePath) {
        return fs
          .readFileSync(filePath)
          .split("\n")
          .map((line) => prefix + line)
          .join("\n");
    });
    data.compiledFileAccess = hb.compile("contents of file {{path}} are: {{catFile path}}")
    data.compiledBenign = hb.compile("hello, {{name}}");
    data.compiledUnknown = hb.compile(fs.readFileSync("greeting.template"));
    data.compiledMixed = hb.compile("helpers may have several args, like here: {{prependToLines prefix path}}");
}

init();

app.get('/some/path1', function (req, res) {
    res.send(data.compiledFileAccess({ path: req.params.path })); // NOT ALLOWED (template uses vulnerable catFile)
});

app.get('/some/path2', function (req, res) {
    res.send(data.compiledBenign({ name: req.params.name })); // ALLOWED (this template does not use catFile)
});

app.get('/some/path3', function (req, res) {
    res.send(data.compiledUnknown({ name: req.params.name })); // ALLOWED (could be using a vulnerable helper, but we'll assume it's ok)
});

app.get('/some/path4', function (req, res) {
    res.send(data.compiledMixed({
        prefix: ">>> ",
        path: req.params.path // NOT ALLOWED (template uses vulnerable helper)
    }));
});

app.get('/some/path5', function (req, res) {
    res.send(data.compiledMixed({
        prefix: req.params.prefix, // ALLOWED (this parameter is safe)
        path: "data/path-5.txt"
    }));
});
