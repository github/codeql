var express = require('express');
var app = express();
var URI = require("urijs");
app.get('/findKey', function(req, res) {
  var key = req.param("key"), input = req.param("input"); // $ Source[js/regex-injection]

  var re = new RegExp("\\b" + key + "=(.*)\n"); // $ Alert[js/regex-injection] - Unsanitized user input is used to construct a regular expression

  function wrap(s) {
    return "\\b" + wrap2(s);
  }

  function wrap2(s) {
    return s + "=(.*)\n";
  }

  new RegExp(wrap(key)); // $ Alert[js/regex-injection]
  new RegExp(wrap(key)); // $ Alert[js/regex-injection] - duplicated to test precision of flow tracking

  function getKey() {
    return req.param("key"); // $ Source[js/regex-injection]
  }
  new RegExp(getKey()); // $ Alert[js/regex-injection]

  function mkRegExp(s) {
    return new RegExp(s); // $ Alert[js/regex-injection]
  }
  mkRegExp(key);
  mkRegExp(getKey());

  var defString = "someString";
  var likelyString = x? defString: 42;
  var notString = {};

  if (defString.match(input)) {} // $ Alert[js/regex-injection]
  if (likelyString.match(input)) {} // $ Alert[js/regex-injection]
  if (maybeString.match(input)) {} // $ Alert[js/regex-injection]
  if (notString.match(input)) {}

  if (defString.search(input) > -1) {} // $ Alert[js/regex-injection]
  if (likelyString.search(input) > -1) {} // $ Alert[js/regex-injection]
  if (maybeString.search(input) > -1) {} // $ Alert[js/regex-injection]
  if (notString.search(input) > -1) {}

  URI(`${protocol}://${host}${path}`).search(input);
  URI(`${protocol}://${host}${path}`).search(input).href();
  unknown.search(input).unknown;

  new RegExp(key.split(".").filter(x => x).join("-")); // $ Alert[js/regex-injection]
});

import * as Search from './search';

app.get('/findKey', function(req, res) {
  var key = req.param("key"), input = req.param("input"); // $ Source[js/regex-injection]

  Search.search(input);

  new RegExp(input); // $ Alert[js/regex-injection]

  var sanitized = input.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
  new RegExp(sanitized);
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
  var input = req.param("input"); // $ Source[js/regex-injection]

  new RegExp(escape1(input));
  new RegExp(escape2(input));

  new RegExp("^.*\.(" + input.replace(/,/g, "|") + ")$"); // $ Alert[js/regex-injection]
});

app.get("argv", function(req, res) {
    new RegExp(`^${process.env.HOME}/Foo/bar.app$`); // environment variable, should be detected only with threat model enabled.

    new RegExp(`^${process.argv[1]}/Foo/bar.app$`); // $ Alert[js/regex-injection]
});

app.get("argv", function(req, res) {
  var input = req.param("input"); // $ Source[js/regex-injection]

  var sanitized = input.replace(new RegExp("[\\-\\[\\]\\/\\{\\}\\(\\)\\*\\+\\?\\.\\\\\\^\\$\\|]"), "\\$&");
  new RegExp(sanitized); // $ Alert[js/regex-injection]

  var sanitized = input.replace(new RegExp("[\\-\\[\\]\\/\\{\\}\\(\\)\\*\\+\\?\\.\\\\\\^\\$\\|]", "g"), "\\$&");
  new RegExp(sanitized);

  var sanitized = input.replace(new RegExp("[\\-\\[\\]\\/\\{\\}\\(\\)\\*\\+\\?\\.\\\\\\^\\$\\|]", unknownFlags()), "\\$&");
  new RegExp(sanitized); // OK - Most likely not a problem.
});
