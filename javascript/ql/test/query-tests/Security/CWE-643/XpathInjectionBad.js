const express = require('express');
const xpath = require('xpath');
const app = express();

app.get('/some/route', function(req, res) {
  let userName = req.param("userName"); // $ Source

  // BAD: Use user-provided data directly in an XPath expression
  let badXPathExpr = xpath.parse("//users/user[login/text()='" + userName + "']/home_dir/text()"); //  $ Alert
  badXPathExpr.select({
    node: root
  });
});
