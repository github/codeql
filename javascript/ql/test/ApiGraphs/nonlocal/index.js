const express = require('express');

var app1 = new express();
app1.get('/',
    (req, res) => res.send('Hello World!') /* def (parameter 1 (member get (instance (member exports (module express))))) */
);

function makeApp() {
    return new express();
}

var app2 = makeApp();
app2.get('/',
    (req, res) => res.send('Hello World!') /* def (parameter 1 (member get (instance (member exports (module express))))) */
);