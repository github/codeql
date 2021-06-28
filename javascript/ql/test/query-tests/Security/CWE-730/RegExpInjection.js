var express = require('express');
var app = express();
var URI = require("urijs");
app.get('/findKey', function(req, res) {
  var key = req.param("key"), input = req.param("input");

  // BAD: Unsanitized user input is used to construct a regular expression
  var re = new RegExp("\\b" + key + "=(.*)\n");

  function wrap(s) {
    return "\\b" + wrap2(s);
  }

  function wrap2(s) {
    return s + "=(.*)\n";
  }

  // NOT OK
  new RegExp(wrap(key));
  // NOT OK (duplicated to test precision of flow tracking)
  new RegExp(wrap(key));

  function getKey() {
    return req.param("key");
  }
  // NOT OK
  new RegExp(getKey());

  function mkRegExp(s) {
    // NOT OK
    return new RegExp(s);
  }
  mkRegExp(key);
  mkRegExp(getKey());

  var defString = "someString";
  var likelyString = x? defString: 42;
  var notString = {};

  if (defString.match(input)) {} // NOT OK
  if (likelyString.match(input)) {} // NOT OK
  if (maybeString.match(input)) {} // NOT OK
  if (notString.match(input)) {} // OK

  defString.search(input); // NOT OK
  likelyString.search(input); // NOT OK
  maybeString.search(input); // NOT OK
  notString.search(input); // OK

  URI(`${protocol}://${host}${path}`).search(input); // OK, but still flagged [INCONSISTENCY]
  URI(`${protocol}://${host}${path}`).search(input).href(); // OK
  unknown.search(input).unknown; // OK

  new RegExp(key.split(".").filter(x => x).join("-")); // NOT OK
});

import * as Search from './search';

app.get('/findKey', function(req, res) {
  var key = req.param("key"), input = req.param("input");

  Search.search(input); // OK!

  new RegExp(input); // NOT OK
  
  var sanitized = input.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
  new RegExp(sanitized); // OK
});

function escape1(pattern) {
  return pattern.replace(/[\x00-\x7f]/g,
    function(s) { return '\\x' + ('00' + s.charCodeAt().toString(16)).substr(-2); });
}

function escape2(str){
  return str.replace(/([\.$?*|{}\(\)\[\]\\\/\+\-^])/g, function(ch){
    return "\\" + ch;
});
};

app.get('/has-sanitizer', function(req, res) {
  var input = req.param("input");

  new RegExp(escape1(input)); // OK
  new RegExp(escape2(input)); // OK

  new RegExp("^.*\.(" + input.replace(/,/g, "|") + ")$"); // NOT OK
});
