var express = require('express');
var app = express();
// ...
app.get('/full-profile/:userId', function(req, res) {

    if (req.signedCookies.loggedInUserId !== req.params.userId) {
        // GOOD: login decision made based on server controlled data
        requireLogin();
    } else {
        // ... show private information
    }

});
