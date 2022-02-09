var express = require('express');
var app = express();

import { JSDOM } from "jsdom";
app.get('/some/path', function (req, res) {
    // NOT OK
    new JSDOM(req.param("wobble"), { runScripts: "dangerously" });

    // OK
    new JSDOM(req.param("wobble"), { runScripts: "outside-only" });
});
