var app = require('express')();

app.get('/user/:id', function(req, res) {
  if (!isValidUserId(req.params.id))
    // BAD: a request parameter is incorporated without validation into the response
    res.send("Unknown user: " + req.params.id);
  else
    // TODO: do something exciting
    ;
});
