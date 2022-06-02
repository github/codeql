const express = require("express");
const mongoose = require('mongoose');
const User = mongoose.model('User', null);

let app = express();

function flowFromSourceToSink() {
  app.post('/isAdmin', (req, res) => {
    User.find({ 'isAdmin': req.body.isAdmin });
  });
}

function flowFromSourceToNotASink() {
  app.post('/isAdmin', (req, res) => {
    console.log(req.body.isAdmin);
  });
}

function notFlowFromSource() {
  User.find({ 'isAdmin': true });
}

function constantExpression() {
  User.find("constant");
}

function notConstantExpression() {
  User.find(UNDEFINED_GLOBAL);
}

function notASink() {
  console.log("someData");
}

function notASinkMultipleReasons() {
  "abc".startsWith("a")
}

/** A function body with a lot of tokens, to test the cut-off on the body tokens feature. */
function veryLongFunctionBody() {
  User.find("a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" +
    "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a" + "a")
}

/**
 * Test the `enclosingFunctionName` feature with anonymous functions that are passed as arguments
 * to named functions.
 */
{
  const identity = x => x;
  // We should name the anonymous function here that's passed as an argument to `identity`.
  identity(() => console.log("someData"));
}


function effectiveSinkAndNotASink(foo) {
  $.ajax({
    "url": foo.bar,
  });
}
