var express = require('express');
var app = express();
// ...
app.get('/full-profile/:userId', function(req, res) {

    if (req.cookies.loggedInUserId !== req.params.userId) { // $ Alert[js/different-kinds-comparison-bypass]
        requireLogin(); // $ MISSING: Alert - login decision made based on user controlled data
    } else {
        // ... show private information
    }

});

app.get('/full-profile/:userId', function(req, res) {

    if (req.signedCookies.loggedInUserId !== req.params.userId) {
        // OK - login decision made based on server controlled data
        requireLogin();
    } else {
        // ... show private information
    }

});
