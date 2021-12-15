var express = require('express'),
    app = express();

app.get('/getFooFile', function(req, res) {
    res.sendFile("foo"); // OK (for now) since this is a server-side response
});
