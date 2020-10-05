# URL redirection from remote source

```
ID: py/url-redirection
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-601

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/python/ql/src/Security/CWE-601/UrlRedirect.ql)

Directly incorporating user input into a URL redirect request without validating the input can facilitate phishing attacks. In these attacks, unsuspecting users can be redirected to a malicious site that looks very similar to the real site they intend to visit, but which is controlled by the attacker.


## Recommendation
To guard against untrusted URL redirection, it is advisable to avoid putting user input directly into a redirect URL. Instead, maintain a list of authorized redirects on the server; then choose from that list based on the user input provided.


## Example
The following example shows an HTTP request parameter being used directly in a URL redirect without validating the input, which facilitates phishing attacks:


```python
from flask import Flask, request, redirect

app = Flask(__name__)

@app.route('/')
def hello():
    target = request.args.get('target', '')
    return redirect(target, code=302)

```
One way to remedy the problem is to validate the user input against a known fixed string before doing the redirection:


```python
from flask import Flask, request, redirect

VALID_REDIRECT = "http://cwe.mitre.org/data/definitions/601.html"

app = Flask(__name__)

@app.route('/')
def hello():
    target = request.args.get('target', '')
    if target == VALID_REDIRECT:
        return redirect(target, code=302)
    else:
        ... # Error

```

## References
* OWASP: [ XSS Unvalidated Redirects and Forwards Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.html).
* Common Weakness Enumeration: [CWE-601](https://cwe.mitre.org/data/definitions/601.html).