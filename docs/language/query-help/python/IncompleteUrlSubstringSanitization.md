# Incomplete URL substring sanitization

```
ID: py/incomplete-url-substring-sanitization
Kind: problem
Severity: warning
Precision: high
Tags: correctness security external/cwe/cwe-20

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/python/ql/src/Security/CWE-020/IncompleteUrlSubstringSanitization.ql)

Sanitizing untrusted URLs is an important technique for preventing attacks such as request forgeries and malicious redirections. Usually, this is done by checking that the host of a URL is in a set of allowed hosts.

However, treating the URL as a string and checking if one of the allowed hosts is a substring of the URL is very prone to errors. Malicious URLs can bypass such security checks by embedding one of the allowed hosts in an unexpected location.

Even if the substring check is not used in a security-critical context, the incomplete check may still cause undesirable behaviors when the check succeeds accidentally.


## Recommendation
Parse a URL before performing a check on its host value, and ensure that the check handles arbitrary subdomain sequences correctly.


## Example
The following example code checks that a URL redirection will reach the `example.com` domain.


```python
from flask import Flask, request, redirect
from urllib.parse import urlparse

app = Flask(__name__)

# Not safe, as "evil-example.net/example.com" would be accepted

@app.route('/some/path/bad1')
def unsafe1(request):
    target = request.args.get('target', '')
    if "example.com" in target:
        return redirect(target)

# Not safe, as "benign-looking-prefix-example.com" would be accepted

@app.route('/some/path/bad2')
def unsafe2(request):
    target = request.args.get('target', '')
    if target.endswith("example.com"):
        return redirect(target)



#Simplest and safest approach is to use an allowlist

@app.route('/some/path/good1')
def safe1(request):
    allowlist = [
        "example.com/home",
        "example.com/login",
    ]
    target = request.args.get('target', '')
    if target in allowlist:
        return redirect(target)

#More complex example allowing sub-domains.

@app.route('/some/path/good2')
def safe2(request):
    target = request.args.get('target', '')
    host = urlparse(target).hostname
    #Note the '.' preceding example.com
    if host and host.endswith(".example.com"):
        return redirect(target)


```
The first two examples show unsafe checks that are easily bypassed. In `unsafe1` the attacker can simply add `example.com` anywhere in the url. For example, `http://evil-example.net/example.com`.

In `unsafe2` the attacker must use a hostname ending in `example.com`, but that is easy to do. For example, `http://benign-looking-prefix-example.com`.

The second two examples show safe checks. In `safe1`, an allowlist is used. Although fairly inflexible, this is easy to get right and is most likely to be safe.

In `safe2`, `urlparse` is used to parse the URL, then the hostname is checked to make sure it ends with `.example.com`.


## References
* OWASP: [SSRF](https://www.owasp.org/index.php/Server_Side_Request_Forgery)
* OWASP: [XSS Unvalidated Redirects and Forwards Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.html).
* Common Weakness Enumeration: [CWE-20](https://cwe.mitre.org/data/definitions/20.html).