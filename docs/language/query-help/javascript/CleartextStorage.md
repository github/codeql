# Clear text storage of sensitive information

```
ID: js/clear-text-storage-of-sensitive-data
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-312 external/cwe/cwe-315 external/cwe/cwe-359

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-312/CleartextStorage.ql)

Sensitive information that is stored unencrypted is accessible to an attacker who gains access to the storage. This is particularly important for cookies, which are stored on the machine of the end-user.


## Recommendation
Ensure that sensitive information is always encrypted before being stored. If possible, avoid placing sensitive information in cookies altogether. Instead, prefer storing, in the cookie, a key that can be used to look up the sensitive information.

In general, decrypt sensitive information only at the point where it is necessary for it to be used in cleartext.

Be aware that external processes often store the `standard out` and `standard error` streams of the application, causing logged sensitive information to be stored as well.


## Example
The following example code stores user credentials (in this case, their password) in a cookie in plain text:


```javascript
var express = require('express');

var app = express();
app.get('/remember-password', function (req, res) {
  let pw = req.param("current_password");
  // BAD: Setting a cookie value with cleartext sensitive data.
  res.cookie("password", pw);
});

```
Instead, the credentials should be encrypted, for instance by using the Node.js `crypto` module:


```javascript
var express = require('express');
var crypto = require('crypto'),
    password = getPassword();

function encrypt(text){
  var cipher = crypto.createCipher('aes-256-ctr', password);
  return cipher.update(text, 'utf8', 'hex') + cipher.final('hex');
}

var app = express();
app.get('/remember-password', function (req, res) {
  let pw = req.param("current_password");
  // GOOD: Encoding the value before setting it.
  res.cookie("password", encrypt(pw));
});

```

## References
* M. Dowd, J. McDonald and J. Schuhm, *The Art of Software Security Assessment*, 1st Edition, Chapter 2 - 'Common Vulnerabilities of Encryption', p. 43. Addison Wesley, 2006.
* M. Howard and D. LeBlanc, *Writing Secure Code*, 2nd Edition, Chapter 9 - 'Protecting Secret Data', p. 299. Microsoft, 2002.
* Common Weakness Enumeration: [CWE-312](https://cwe.mitre.org/data/definitions/312.html).
* Common Weakness Enumeration: [CWE-315](https://cwe.mitre.org/data/definitions/315.html).
* Common Weakness Enumeration: [CWE-359](https://cwe.mitre.org/data/definitions/359.html).