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

var app = express();

app.get('/some/path', function(req, res) {
    let tainted = req.query.foo;

    pug.compile(tainted); // NOT OK
    pug.render(tainted); // NOT OK
    jade.compile(tainted); // NOT OK
    jade.render(tainted); // NOT OK
    dot.template(tainted); // NOT OK
    ejs.render(tainted); // NOT OK
    nunjucks.renderString(tainted); // NOT OK
    lodash.template(tainted); // NOT OK
    dot.compile(tainted); // NOT OK
    handlebars.compile(tainted); // NOT OK
    mustache.render(tainted); // NOT OK
    Hogan.compile(tainted); // NOT OK
    Eta.render(tainted); // NOT OK
    Sqrl.render(tainted); // NOT OK
});
