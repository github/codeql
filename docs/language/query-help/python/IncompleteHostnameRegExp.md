# Incomplete regular expression for hostnames

```
ID: py/incomplete-hostname-regexp
Kind: problem
Severity: warning
Precision: high
Tags: correctness security external/cwe/cwe-20

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/python/ql/src/Security/CWE-020/IncompleteHostnameRegExp.ql)

Sanitizing untrusted URLs is an important technique for preventing attacks such as request forgeries and malicious redirections. Often, this is done by checking that the host of a URL is in a set of allowed hosts.

If a regular expression implements such a check, it is easy to accidentally make the check too permissive by not escaping the `.` meta-characters appropriately. Even if the check is not used in a security-critical context, the incomplete check may still cause undesirable behaviors when it accidentally succeeds.


## Recommendation
Escape all meta-characters appropriately when constructing regular expressions for security checks, pay special attention to the `.` meta-character.


## Example
The following example code checks that a URL redirection will reach the `example.com` domain, or one of its subdomains.


```python
from flask import Flask, request, redirect
import re

app = Flask(__name__)

UNSAFE_REGEX = re.compile("(www|beta).example.com/")
SAFE_REGEX = re.compile(r"(www|beta)\.example\.com/")

@app.route('/some/path/bad')
def unsafe(request):
    target = request.args.get('target', '')
    if UNSAFE_REGEX.match(target):
        return redirect(target)

@app.route('/some/path/good')
def safe(request):
    target = request.args.get('target', '')
    if SAFE_REGEX.match(target):
        return redirect(target)

```
The `unsafe` check is easy to bypass because the unescaped `.` allows for any character before `example.com`, effectively allowing the redirect to go to an attacker-controlled domain such as `wwwXexample.com`.

The `safe` check closes this vulnerability by escaping the `.` so that URLs of the form `wwwXexample.com` are rejected.


## References
* OWASP: [SSRF](https://www.owasp.org/index.php/Server_Side_Request_Forgery)
* OWASP: [XSS Unvalidated Redirects and Forwards Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.html).
* Common Weakness Enumeration: [CWE-20](https://cwe.mitre.org/data/definitions/20.html).