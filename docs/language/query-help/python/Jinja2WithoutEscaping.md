# Jinja2 templating with autoescape=False

```
ID: py/jinja2/autoescape-false
Kind: problem
Severity: error
Precision: medium
Tags: security external/cwe/cwe-079

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/python/ql/src/Security/CWE-079/Jinja2WithoutEscaping.ql)

Cross-site scripting (XSS) attacks can occur if untrusted input is not escaped. This applies to templates as well as code. The `jinja2` templates may be vulnerable to XSS if the environment has `autoescape` set to `False`. Unfortunately, `jinja2` sets `autoescape` to `False` by default. Explicitly setting `autoescape` to `True` when creating an `Environment` object will prevent this.


## Recommendation
Avoid setting jinja2 autoescape to False. Jinja2 provides the function `select_autoescape` to make sure that the correct auto-escaping is chosen. For example, it can be used when creating an environment `Environment(autoescape=select_autoescape(['html', 'xml'])`


## Example
The following example is a minimal Flask app which shows a safe and an unsafe way to render the given name back to the page. The first view is unsafe as `first_name` is not escaped, leaving the page vulnerable to cross-site scripting attacks. The second view is safe as `first_name` is escaped, so it is not vulnerable to cross-site scripting attacks.


```python
from flask import Flask, request, make_response, escape
from jinja2 import Environment, select_autoescape, FileSystemLoader

app = Flask(__name__)
loader = FileSystemLoader( searchpath="templates/" )

unsafe_env = Environment(loader=loader)
safe1_env = Environment(loader=loader, autoescape=True)
safe2_env = Environment(loader=loader, autoescape=select_autoescape())

def render_response_from_env(env):
    name = request.args.get('name', '')
    template = env.get_template('template.html')
    return make_response(template.render(name=name))

@app.route('/unsafe')
def unsafe():
    return render_response_from_env(unsafe_env)

@app.route('/safe1')
def safe1():
    return render_response_from_env(safe1_env)

@app.route('/safe2')
def safe2():
    return render_response_from_env(safe2_env)


```

## References
* Jinja2: [API](http://jinja.pocoo.org/docs/2.10/api/).
* Wikipedia: [Cross-site scripting](http://en.wikipedia.org/wiki/Cross-site_scripting).
* OWASP: [XSS (Cross Site Scripting) Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html).
* Common Weakness Enumeration: [CWE-79](https://cwe.mitre.org/data/definitions/79.html).