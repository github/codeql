var express = require('express');
var app = express();
// ...
app.get('/full-profile/:userId', function(req, res) {

    if (req.cookies.loggedInUserId !== req.params.userId) {
        // BAD: login decision made based on user controlled data
        requireLogin();
    } else {
        // ... show private information
    }

});
