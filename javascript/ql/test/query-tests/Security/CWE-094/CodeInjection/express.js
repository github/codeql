var express = require('express');

var app = express();

app.get('/some/path', function(req, res) {
  // NOT OK
  var f = new Function("return wibbles[" + req.param("wobble") + "];");
  // NOT OK
  require("vm").runInThisContext("return wibbles[" + req.param("wobble") + "];");
  var runC = require("vm").runInNewContext;
  // NOT OK
  runC("return wibbles[" + req.param("wobble") + "];");
  var vm = require("vm");
  // NOT OK
  vm.compileFunction(req.param("code_compileFunction"));
  // NOT OK
  var script = new vm.Script(req.param("code_Script"));
  // NOT OK
  var mdl = new vm.SourceTextModule(req.param("code_SourceTextModule"));
  // NOT OK
  vm.runInContext(req.param("code_runInContext"), vm.createContext());
});

const cp = require('child_process');
app.get('/other/path', function(req, res) {
  const taint = req.param("wobble");
  cp.execFileSync('node', ['-e', taint]); // NOT OK

  cp.execFileSync('node', ['-e', `console.log(${JSON.stringify(taint)})`]); // OK
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

  shell.write(taint); // NOT OK
});
  
require("express-ws")(app);

app.ws("/socket-thing/", function (ws, req) {
  ws.on("message", function (msg) {
    eval(msg); // NOT OK
  });
});
