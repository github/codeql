var acorn = require('acorn'),
    express = require('express'),
    x = require("prefix!used-in-require-with-exclamation-mark-separator");

var constantTemplateRequire = require(`used-in-constant-template-require-string`);
var dynamic = "dynamic";
var dynamicTemplateRequire = require(`used-in-${dynamic}-template-require-string`);
var sillyTemplateRequire = require(`${"used-in-silly-template-require-string"}`);
alert("Hello");

let app = express();
app.set('view engine', '.jade');
app.set('view engine', 'ejs');
