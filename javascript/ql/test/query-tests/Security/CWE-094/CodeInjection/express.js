var express = require('express');

var app = express();

app.get('/some/path', function(req, res) {
  var f = new Function("return wibbles[" + req.param("wobble") + "];"); // $ Alert[js/code-injection]
  require("vm").runInThisContext("return wibbles[" + req.param("wobble") + "];"); // $ Alert[js/code-injection]
  var runC = require("vm").runInNewContext;
  runC("return wibbles[" + req.param("wobble") + "];"); // $ Alert[js/code-injection]
  var vm = require("vm");
  vm.compileFunction(req.param("code_compileFunction")); // $ Alert[js/code-injection]
  var script = new vm.Script(req.param("code_Script")); // $ Alert[js/code-injection]
  var mdl = new vm.SourceTextModule(req.param("code_SourceTextModule")); // $ Alert[js/code-injection]
  vm.runInContext(req.param("code_runInContext"), vm.createContext()); // $ Alert[js/code-injection]
});

const cp = require('child_process');
app.get('/other/path', function(req, res) {
  const taint = req.param("wobble"); // $ Source[js/code-injection]
  cp.execFileSync('node', ['-e', taint]); // $ Alert[js/code-injection]

  cp.execFileSync('node', ['-e', `console.log(${JSON.stringify(taint)})`]);
});

const pty = require('node-pty');
app.get('/terminal', function(req, res) {
  const taint = req.param("wobble"); // $ Source[js/code-injection]
  const shell = pty.spawn('bash', [], {
    name: 'xterm-color',
    cols: 80,
    rows: 30,
    cwd: process.env.HOME,
    env: process.env
  });

  shell.write(taint); // $ Alert[js/code-injection]
});
  
require("express-ws")(app);

app.ws("/socket-thing/", function (ws, req) {
  ws.on("message", function (msg) { // $ Source[js/code-injection]
    eval(msg); // $ Alert[js/code-injection]
  });
});
