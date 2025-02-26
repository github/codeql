import express from 'express';
import * as pug from 'pug';
import * as jade from 'jade';
import * as dot from 'dot';
import * as ejs from 'ejs';
import * as nunjucks from 'nunjucks';
import * as lodash from 'lodash';
import * as handlebars from 'handlebars';
import * as mustache from 'mustache';
const Hogan = require("hogan.js");
import * as Eta from 'eta';
import * as Sqrl from 'squirrelly'
import * as webix from "webix";

var app = express();

app.get('/some/path', function (req, res) {
    let tainted = req.query.foo; // $ Source[js/code-injection]

    pug.compile(tainted); // $ Alert[js/code-injection]
    pug.render(tainted); // $ Alert[js/code-injection]
    jade.compile(tainted); // $ Alert[js/code-injection]
    jade.render(tainted); // $ Alert[js/code-injection]
    dot.template(tainted); // $ Alert[js/code-injection]
    ejs.render(tainted); // $ Alert[js/code-injection]
    nunjucks.renderString(tainted); // $ Alert[js/code-injection]
    lodash.template(tainted); // $ Alert[js/code-injection]
    dot.compile(tainted); // $ Alert[js/code-injection]
    handlebars.compile(tainted); // $ Alert[js/code-injection]
    mustache.render(tainted); // $ Alert[js/code-injection]
    Hogan.compile(tainted); // $ Alert[js/code-injection]
    Eta.render(tainted); // $ Alert[js/code-injection]
    Sqrl.render(tainted); // $ Alert[js/code-injection]
});
