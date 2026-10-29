const express = require('express');
const xpath = require('xpath');
const app = express();

app.get('/some/route', function(req, res) {
  let userName = req.param("userName");

  // GOOD: Embed user-provided data using variables
  let goodXPathExpr = xpath.parse("//users/user[login/text()=$userName]/home_dir/text()");
  goodXPathExpr.select({
    node: root,
    variables: { userName: userName }
  });
});
