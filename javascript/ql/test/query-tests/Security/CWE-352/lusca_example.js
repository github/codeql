var express = require('express')
var cookieParser = require('cookie-parser')
var bodyParser = require('body-parser')

var parseForm = bodyParser.urlencoded({ extended: false })
var lusca = require('lusca');

var app = express()
app.use(cookieParser())

app.post('/process', parseForm, lusca.csrf(), function (req, res) { // OK
  let newEmail = req.cookies["newEmail"];
  res.send('data is being processed')
})

app.post('/process', parseForm, lusca({csrf:true}), function (req, res) { // OK
  let newEmail = req.cookies["newEmail"];
  res.send('data is being processed')
})

app.post('/process', parseForm, lusca({csrf:{}}), function (req, res) { // OK
  let newEmail = req.cookies["newEmail"];
  res.send('data is being processed')
})

app.post('/process', parseForm, lusca(), function (req, res) { // NOT OK - missing csrf option
  let newEmail = req.cookies["newEmail"];
  res.send('data is being processed')
})

app.post('/process_unsafe', parseForm, function (req, res) { // NOT OK
  let newEmail = req.cookies["newEmail"];
  res.send('data is being processed')
})
