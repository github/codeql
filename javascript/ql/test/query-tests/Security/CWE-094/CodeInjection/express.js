var express = require('express');

var app = express();

app.get('/some/path', function(req, res) {
  var f = new Function("return wibbles[" + req.param("wobble") + "];"); // $ Alert
  require("vm").runInThisContext("return wibbles[" + req.param("wobble") + "];"); // $ Alert
  var runC = require("vm").runInNewContext;
  runC("return wibbles[" + req.param("wobble") + "];"); // $ Alert
  var vm = require("vm");
  vm.compileFunction(req.param("code_compileFunction")); // $ Alert
  var script = new vm.Script(req.param("code_Script")); // $ Alert
  var mdl = new vm.SourceTextModule(req.param("code_SourceTextModule")); // $ Alert
  vm.runInContext(req.param("code_runInContext"), vm.createContext()); // $ Alert
});

const cp = require('child_process');
app.get('/other/path', function(req, res) {
  const taint = req.param("wobble");
  cp.execFileSync('node', ['-e', taint]); // $ Alert[js/code-injection]

  cp.execFileSync('node', ['-e', `console.log(${JSON.stringify(taint)})`]);
});

const pty = require('node-pty');
app.get('/terminal', function(req, res) {
  const taint = req.param("wobble");
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
  ws.on("message", function (msg) {
    eval(msg); // $ Alert[js/code-injection]
  });
});
