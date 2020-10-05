# Flask app is run in debug mode

```
ID: py/flask-debug
Kind: problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-215 external/cwe/cwe-489

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/python/ql/src/Security/CWE-215/FlaskDebug.ql)

Running a Flask application with debug mode enabled may allow an attacker to gain access through the Werkzeug debugger.


## Recommendation
Ensure that Flask applications that are run in a production environment have debugging disabled.


## Example
Running the following code starts a Flask webserver that has debugging enabled. By visiting `/crash`, it is possible to gain access to the debugger, and run arbitrary code through the interactive debugger.


```python
from flask import Flask

app = Flask(__name__)

@app.route('/crash')
def main():
    raise Exception()

app.run(debug=True)

```

## References
* Flask Quickstart Documentation: [Debug Mode](http://flask.pocoo.org/docs/1.0/quickstart/#debug-mode).
* Werkzeug Documentation: [Debugging Applications](http://werkzeug.pocoo.org/docs/0.14/debug/).
* Common Weakness Enumeration: [CWE-215](https://cwe.mitre.org/data/definitions/215.html).
* Common Weakness Enumeration: [CWE-489](https://cwe.mitre.org/data/definitions/489.html).