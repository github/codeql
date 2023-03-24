var express = require('express');
var multer  = require('multer');
var upload = multer({ dest: 'uploads/' });
 
var app = express();
var exec = require("child_process").exec;
 
app.post('/profile', upload.single('avatar'), function (req, res, next) {
  exec("touch " + req.file.originalname); // NOT OK
});
 
app.post('/photos/upload', upload.array('photos', 12), function (req, res, next) {
  req.files.forEach(file => {
    exec("touch " + file.originalname); // NOT OK
  })
});


var http = require('http');
var Busboy = require('busboy');

http.createServer(function (req, res) {
  var busboy = new Busboy({ headers: req.headers });
  busboy.on('file', function (fieldname, file, filename, encoding, mimetype) {
    exec("touch " + filename); // NOT OK
  });
  req.pipe(busboy);
}).listen(8000);


const formidable = require('formidable'); 
app.post('/api/upload', (req, res, next) => {
  let form = formidable({ multiples: true });
 
  form.parse(req, (err, fields, files) => {
    exec("touch " + fields.name); // NOT OK
  });

  let form2 = new formidable.IncomingForm();
  form2.parse(req, (err, fields, files) => {
    exec("touch " + fields.name); // NOT OK
  });
});

var multiparty = require('multiparty');
var http = require('http');

http.createServer(function (req, res) {
  // parse a file upload
  var form = new multiparty.Form();

  form.parse(req, function (err, fields, files) {
    exec("touch " + fields.name); // NOT OK
  });


  var form2 = new multiparty.Form();
  form2.on('part', function (part) { // / file / field
    exec("touch " + part.filename); // NOT OK
  });
  form2.parse(req);

}).listen(8080);
