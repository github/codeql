const express = require('express');
const xpath = require('xpath');
const app = express();

app.get('/some/route', function(req, res) {
  let userName = req.param("userName"); // $ Source

  let badXPathExpr = xpath.parse("//users/user[login/text()='" + userName + "']/home_dir/text()"); // $ Alert - Use user-provided data directly in an XPath expression
  badXPathExpr.select({
    node: root
  });
});
