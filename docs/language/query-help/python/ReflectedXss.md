# Reflected server-side cross-site scripting

```
ID: py/reflective-xss
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-079 external/cwe/cwe-116

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/python/ql/src/Security/CWE-079/ReflectedXss.ql)

Directly writing user input (for example, an HTTP request parameter) to a webpage without properly sanitizing the input first, allows for a cross-site scripting vulnerability.


## Recommendation
To guard against cross-site scripting, consider escaping the input before writing user input to the page. The standard library provides escaping functions: `html.escape()` for Python 3.2 upwards or `cgi.escape()` older versions of Python. Most frameworks also provide their own escaping functions, for example `flask.escape()`.


## Example
The following example is a minimal flask app which shows a safe and unsafe way to render the given name back to the page. The first view is unsafe as `first_name` is not escaped, leaving the page vulnerable to cross-site scripting attacks. The second view is safe as `first_name` is escaped, so it is not vulnerable to cross-site scripting attacks.


```python
from flask import Flask, request, make_response, escape

app = Flask(__name__)

@app.route('/unsafe')
def unsafe():
    first_name = request.args.get('name', '')
    return make_response("Your name is " + first_name)

@app.route('/safe')
def safe():
    first_name = request.args.get('name', '')
    return make_response("Your name is " + escape(first_name))

```

## References
* OWASP: [XSS (Cross Site Scripting) Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html).
* Wikipedia: [Cross-site scripting](http://en.wikipedia.org/wiki/Cross-site_scripting).
* Python Library Reference: [html.escape()](https://docs.python.org/3/library/html.html#html.escape).
* Common Weakness Enumeration: [CWE-79](https://cwe.mitre.org/data/definitions/79.html).
* Common Weakness Enumeration: [CWE-116](https://cwe.mitre.org/data/definitions/116.html).