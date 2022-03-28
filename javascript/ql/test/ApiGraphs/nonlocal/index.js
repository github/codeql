const express = require('express');

var app1 = new express();
app1.get('/',
    (req, res) => res.send('Hello World!') /* def=moduleImport("express").getMember("exports").getInstance().getMember("get").getParameter(1) */
);

function makeApp() {
    return new express();
}

var app2 = makeApp();
app2.get('/',
    (req, res) => res.send('Hello World!') /* def=moduleImport("express").getMember("exports").getInstance().getMember("get").getParameter(1) */
);