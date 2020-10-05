# Uncontrolled command line

```
ID: js/command-line-injection
Kind: path-problem
Severity: error
Precision: high
Tags: correctness security external/cwe/cwe-078 external/cwe/cwe-088

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-078/CommandInjection.ql)

Code that passes user input directly to `require('child_process').exec`, or some other library routine that executes a command, allows the user to execute malicious code.


## Recommendation
If possible, use hard-coded string literals to specify the command to run or library to load. Instead of passing the user input directly to the process or library function, examine the user input and then choose among hard-coded string literals.

If the applicable libraries or commands cannot be determined at compile time, then add code to verify that the user input string is safe before using it.


## Example
The following example shows code that takes a shell script that can be changed maliciously by a user, and passes it straight to `child_process.exec` without examining it first.


```javascript
var cp = require("child_process"),
    http = require('http'),
    url = require('url');

var server = http.createServer(function(req, res) {
    let cmd = url.parse(req.url, true).query.path;

    cp.exec(cmd); // BAD
});

```

## References
* OWASP: [Command Injection](https://www.owasp.org/index.php/Command_Injection).
* Common Weakness Enumeration: [CWE-78](https://cwe.mitre.org/data/definitions/78.html).
* Common Weakness Enumeration: [CWE-88](https://cwe.mitre.org/data/definitions/88.html).