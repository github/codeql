var express = require('express');
var multer  = require('multer');
var upload = multer({ dest: 'uploads/' });
 
var app = express();
var exec = require("child_process").exec;
 
app.post('/profile', upload.single('avatar'), function (req, res, next) {
  exec("touch " + req.file.originalname); // $ Alert
});
 
app.post('/photos/upload', upload.array('photos', 12), function (req, res, next) {
  req.files.forEach(file => { // $ Source
    exec("touch " + file.originalname); // $ Alert
  })
});


var http = require('http');
var Busboy = require('busboy');

http.createServer(function (req, res) {
  var busboy = new Busboy({ headers: req.headers });
  busboy.on('file', function (fieldname, file, filename, encoding, mimetype) { // $ Source
    exec("touch " + filename); // $ Alert
  });
  req.pipe(busboy);
}).listen(8000);


const formidable = require('formidable'); 
app.post('/api/upload', (req, res, next) => {
  let form = formidable({ multiples: true });
 
  form.parse(req, (err, fields, files) => { // $ Source
    exec("touch " + fields.name); // $ Alert
  });

  let form2 = new formidable.IncomingForm();
  form2.parse(req, (err, fields, files) => { // $ Source
    exec("touch " + fields.name); // $ Alert
  });
});

var multiparty = require('multiparty');
var http = require('http');

http.createServer(function (req, res) {
  // parse a file upload
  var form = new multiparty.Form();

  form.parse(req, function (err, fields, files) { // $ Source
    exec("touch " + fields.name); // $ Alert
  });


  var form2 = new multiparty.Form();
  form2.on('part', function (part) { // $ Source - / file / field
    exec("touch " + part.filename); // $ Alert
  });
  form2.parse(req);

}).listen(8080);
