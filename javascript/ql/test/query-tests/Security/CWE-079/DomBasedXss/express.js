var express = require('express');
var app = express();

import { JSDOM } from "jsdom";
app.get('/some/path', function (req, res) {
    new JSDOM(req.param("wobble"), { runScripts: "dangerously" }); // $ Alert


    new JSDOM(req.param("wobble"), { runScripts: "outside-only" });
});
