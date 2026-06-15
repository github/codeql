var express = require('express');
var app = express();
import jwt from "jsonwebtoken";

import { JSDOM } from "jsdom";
app.get('/some/path', function (req, res) {
    var taint = req.param("wobble"); // $ Source

    jwt.verify(taint, 'my-secret-key', function (err, decoded) {
        new JSDOM(decoded.foo, { runScripts: "dangerously" }); // $ Alert
    });
});
