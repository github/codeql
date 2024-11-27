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

  if (defString.search(input) > -1) {} // NOT OK
  if (likelyString.search(input) > -1) {} // NOT OK
  if (maybeString.search(input) > -1) {} // NOT OK
  if (notString.search(input) > -1) {} // OK

  URI(`${protocol}://${host}${path}`).search(input); // OK
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

app.get("argv", function(req, res) {
    new RegExp(`^${process.env.HOME}/Foo/bar.app$`); // NOT OK

    new RegExp(`^${process.argv[1]}/Foo/bar.app$`); // NOT OK
});

app.get("argv", function(req, res) {
  var input = req.param("input");

  var sanitized = input.replace(new RegExp("[\\-\\[\\]\\/\\{\\}\\(\\)\\*\\+\\?\\.\\\\\\^\\$\\|]"), "\\$&");
  new RegExp(sanitized); // NOT OK
  
  var sanitized = input.replace(new RegExp("[\\-\\[\\]\\/\\{\\}\\(\\)\\*\\+\\?\\.\\\\\\^\\$\\|]", "g"), "\\$&");
  new RegExp(sanitized); // OK

  var sanitized = input.replace(new RegExp("[\\-\\[\\]\\/\\{\\}\\(\\)\\*\\+\\?\\.\\\\\\^\\$\\|]", unknownFlags()), "\\$&");
  new RegExp(sanitized); // OK -- Most likely not a problem.
});
