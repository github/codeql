let express = require('express');
let app = express();

app.get("/some/path", (req, res) => {
  new Promise((resolve, reject) => resolve(req.query.data)) // $ Source
    .then(x => res.send(x)); // $ Alert

  new Promise((resolve, reject) => resolve(req.query.data))
    .then(x => escapeHtml(x))
    .then(x => res.send(x));
});
