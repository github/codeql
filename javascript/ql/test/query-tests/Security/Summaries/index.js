var http = require('http'),
    url = require('url');

function listenForHeaders(cb) {
  http.createServer(function (req, res) {
    let cmd = url.parse(req.url, true).query.path;
    cb(cmd); // sink
    res.write('Hello World!');
    res.end();
  }).listen(8080);
};

function codeInjection(input) {
  eval("url[" + input + "]");  
}

function commandInjection(input) {
  require("child_process").exec("ls " + input);  
}

function multiple(input) {
  codeInjection(input);
  commandInjection(input);
}

function taintedPath(input) {
  require("/tmp/" + input);
}

function regexpInj(data) {
  new RegExp("^"+ data.name + "$", "i");
}

function xpathInj(userName) {
  const xpath = require('xpath');
  let badXPathExpr = xpath.parse("//users/user[login/text()='" + userName + "']/home_dir/text()");
  badXPathExpr.select({
    node: root
  });
}

function xxe(input) {
  const expat = require('node-expat');
  var parser = new expat.Parser();
  parser.write(input); 
}


function xmlBomb(input) {
  const libxmljs = require('libxmljs');  
  libxmljs.parseXml(input, { noent: true });

}

function hashPass(input) {  
  require('crypto').createCipher('aes192').write(input);
  codeInjection(input)
}

function unsafeDes(input) {
  const jsyaml = require("js-yaml");  
  let data;
  return jsyaml.load(input);
}

function remoteProp(input1, input2, input3) {
  var obj = url[input1]; 
  obj[input2] = input3;  
}

function reflected(userID) {
  var express = require('express');

  var app = express();

  app.get('/user/:id', function(req, res) {    
      res.send("Unknown user: " + userID);   
  });  
}

function redirect(input) {
  var https = require('https');
  var url = require('url');

  var server = https.createServer(function(req, res) {    
    res.writeHead(302, { Location: '/' + input});
  }).listen(8080)
  
}

function sqlInj(input) {  
  var mysql      = require('mysql');
  var connection = mysql.createConnection({
    host     : 'localhost',
    user     : 'me',
    password : 'secret',
    database : 'my_db'
  });   
  connection.connect();
  connection.query('SELECT ' + input + ' AS solution', function (error, results, fields) {
    if (error) throw error;
    console.log('The solution is: ', results[0].solution);
  });
}

function createError () {
  var err, status;  
  for (i = 0; i < 1000; i++) {    
    err = {};
    status = err.a || err.b || err.c || err.d || err;          
  }
    
  err.a = err.b = status 

  return err;
}

function forLoop(input) {
  var intObj = {};
  var res = 0;
  for (var i = 0; i < input.x.length; i++) {
    res += intObj.x + input.x[i];
  }
  if (res < 1000) {
    intObj.res = res;
    return intObj;
  } else 
    return res;
}

function notASink(foo) {
  return foo;
}

// this call should not make parameter `foo` a command injection sink
eval(notASink(42));

function taintedSource() {
  return location.search;
}

function notATaintedSource(x) {
  return x;
}

// this call should not make the return value of `notATaintedSource` a remote flow source
notATaintedSource(location.search);

function invoke(cb, x) {
  cb(x);
}

// this call should not make the first argument to `cb` above a remote flow source
invoke((x)=>x, location.search);

function g(x) {
  h(x);
}

function h(y) {
  return y;
}

function mkdirp(path) {
  path /* Semmle: sink: taint, TaintedPath */
}

module.exports = {
    codeInjection: codeInjection,
    commandInjection: commandInjection,
    remotePropeInjection: remoteProp,
    multiple: multiple,
    taintedPath: taintedPath,
    sqlInj: sqlInj,
    listen: listenForHeaders,
    createError: createError,
    regexpInj: regexpInj,
    xpathInj: xpathInj,
    xmlBomb: xmlBomb,
    hashPass: hashPass,
    xxe: xxe,
    unsafeDes: unsafeDes,
    redirect: redirect,
    reflected: reflected,
    notASink: notASink,
    taintedSource: taintedSource,
    notATaintedSource: notATaintedSource,
    invoke: invoke,
    g: g,
    h: h,
    mkdirp: mkdirp
}
