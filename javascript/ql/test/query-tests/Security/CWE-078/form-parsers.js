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
