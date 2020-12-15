import express from 'express';
import * as pug from 'pug';
import * as jade from 'jade';
import * as dot from 'dot';
import * as ejs from 'ejs';
import * as nunjucks from 'nunjucks';
import * as lodash from 'lodash';

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
});
