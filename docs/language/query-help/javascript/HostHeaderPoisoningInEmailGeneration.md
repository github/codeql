# Host header poisoning in email generation

```
ID: js/host-header-forgery-in-email-generation
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-640

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-640/HostHeaderPoisoningInEmailGeneration.ql)

Using the HTTP Host header to construct a link in an email can facilitate phishing attacks and leak password reset tokens. A malicious user can send an HTTP request to the targeted web site, but with a Host header that refers to his own web site. This means the emails will be sent out to potential victims, originating from a server they trust, but with links leading to a malicious web site.

If the email contains a password reset link, and should the victim click the link, the secret reset token will be leaked to the attacker. Using the leaked token, the attacker can then construct the real reset link and use it to change the victim's password.


## Recommendation
Obtain the server's host name from a configuration file and avoid relying on the Host header.


## Example
The following example uses the `req.host` to generate a password reset link. This value is derived from the Host header, and can thus be set to anything by an attacker:


```javascript
let nodemailer = require('nodemailer');
let express = require('express');
let backend = require('./backend');

let app = express();

let config = JSON.parse(fs.readFileSync('config.json', 'utf8'));

app.post('/resetpass', (req, res) => {
  let email = req.query.email;
  let transport = nodemailer.createTransport(config.smtp);
  let token = backend.getUserSecretResetToken(email);
  transport.sendMail({
    from: 'webmaster@example.com',
    to: email,
    subject: 'Forgot password',
    text: `Click to reset password: https://${req.host}/resettoken/${token}`,
  });
});

```
To ensure the link refers to the correct web site, get the host name from a configuration file:


```javascript
let nodemailer = require('nodemailer');
let express = require('express');
let backend = require('./backend');

let app = express();

let config = JSON.parse(fs.readFileSync('config.json', 'utf8'));

app.post('/resetpass', (req, res) => {
  let email = req.query.email;
  let transport = nodemailer.createTransport(config.smtp);
  let token = backend.getUserSecretResetToken(email);
  transport.sendMail({
    from: 'webmaster@example.com',
    to: email,
    subject: 'Forgot password',
    text: `Click to reset password: https://${config.hostname}/resettoken/${token}`,
  });
});

```

## References
* Mitre: [CWE-640: Weak Password Recovery Mechanism for Forgotten Password](https://cwe.mitre.org/data/definitions/640.html).
* Ian Muscat: [What is a Host Header Attack?](https://www.acunetix.com/blog/articles/automated-detection-of-host-header-attacks/).
* Common Weakness Enumeration: [CWE-640](https://cwe.mitre.org/data/definitions/640.html).