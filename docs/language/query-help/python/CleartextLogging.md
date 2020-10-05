# Clear-text logging of sensitive information

```
ID: py/clear-text-logging-sensitive-data
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-312 external/cwe/cwe-315 external/cwe/cwe-359

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/python/ql/src/Security/CWE-312/CleartextLogging.ql)

Sensitive information that is stored unencrypted is accessible to an attacker who gains access to the storage. This is particularly important for cookies, which are stored on the machine of the end-user.


## Recommendation
Ensure that sensitive information is always encrypted before being stored. If possible, avoid placing sensitive information in cookies altogether. Instead, prefer storing, in the cookie, a key that can be used to look up the sensitive information.

In general, decrypt sensitive information only at the point where it is necessary for it to be used in cleartext.

Be aware that external processes often store the `standard out` and `standard error` streams of the application, causing logged sensitive information to be stored as well.


## Example
The following example code stores user credentials (in this case, their password) in a cookie in plain text:


```python
from flask import Flask, make_response, request

app = Flask("Leak password")

@app.route('/')
def index():
    password = request.args.get("password")
    resp = make_response(render_template(...))
    resp.set_cookie("password", password)
    return resp

```
Instead, the credentials should be encrypted, for instance by using the `cryptography` module, or not stored at all.


## References
* M. Dowd, J. McDonald and J. Schuhm, *The Art of Software Security Assessment*, 1st Edition, Chapter 2 - 'Common Vulnerabilities of Encryption', p. 43. Addison Wesley, 2006.
* M. Howard and D. LeBlanc, *Writing Secure Code*, 2nd Edition, Chapter 9 - 'Protecting Secret Data', p. 299. Microsoft, 2002.
* Common Weakness Enumeration: [CWE-312](https://cwe.mitre.org/data/definitions/312.html).
* Common Weakness Enumeration: [CWE-315](https://cwe.mitre.org/data/definitions/315.html).
* Common Weakness Enumeration: [CWE-359](https://cwe.mitre.org/data/definitions/359.html).