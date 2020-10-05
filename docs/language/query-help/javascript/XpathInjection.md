# XPath injection

```
ID: js/xpath-injection
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-643

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-643/XpathInjection.ql)

If an XPath expression is built using string concatenation, and the components of the concatenation include user input, it makes it very easy for a user to create a malicious XPath expression.


## Recommendation
If user input must be included in an XPath expression, either sanitize the data or use variable references to safely embed it without altering the structure of the expression.


## Example
In this example, the code accepts a user name specified by the user, and uses this unvalidated and unsanitized value in an XPath expression constructed using the `xpath` package. This is vulnerable to the user providing special characters or string sequences that change the meaning of the XPath expression to search for different values.


```javascript
const express = require('express');
const xpath = require('xpath');
const app = express();

app.get('/some/route', function(req, res) {
  let userName = req.param("userName");

  // BAD: Use user-provided data directly in an XPath expression
  let badXPathExpr = xpath.parse("//users/user[login/text()='" + userName + "']/home_dir/text()");
  badXPathExpr.select({
    node: root
  });
});

```
Instead, embed the user input using the variable replacement mechanism offered by `xpath`:


```javascript
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

```

## References
* OWASP: [Testing for XPath Injection](https://www.owasp.org/index.php?title=Testing_for_XPath_Injection_(OTG-INPVAL-010)).
* OWASP: [XPath Injection](https://www.owasp.org/index.php/XPATH_Injection).
* npm: [xpath](https://www.npmjs.com/package/xpath).
* Common Weakness Enumeration: [CWE-643](https://cwe.mitre.org/data/definitions/643.html).