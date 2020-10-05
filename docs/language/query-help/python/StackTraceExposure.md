# Information exposure through an exception

```
ID: py/stack-trace-exposure
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-209 external/cwe/cwe-497

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/python/ql/src/Security/CWE-209/StackTraceExposure.ql)

Software developers often add stack traces to error messages, as a debugging aid. Whenever that error message occurs for an end user, the developer can use the stack trace to help identify how to fix the problem. In particular, stack traces can tell the developer more about the sequence of events that led to a failure, as opposed to merely the final state of the software when the error occurred.

Unfortunately, the same information can be useful to an attacker. The sequence of class names in a stack trace can reveal the structure of the application as well as any internal components it relies on. Furthermore, the error message at the top of a stack trace can include information such as server-side file names and SQL code that the application relies on, allowing an attacker to fine-tune a subsequent injection attack.


## Recommendation
Send the user a more generic error message that reveals less information. Either suppress the stack trace entirely, or log it only on the server.


## Example
In the following example, an exception is handled in two different ways. In the first version, labeled BAD, the exception is sent back to the remote user by returning it from the function. As such, the user is able to see a detailed stack trace, which may contain sensitive information. In the second version, the error message is logged only on the server, and a generic error message is displayed to the user. That way, the developers can still access and use the error log, but remote users will not see the information.


```python
from flask import Flask
app = Flask(__name__)


import traceback

def do_computation():
    raise Exception("Secret info")

# BAD
@app.route('/bad')
def server_bad():
    try:
        do_computation()
    except Exception as e:
        return traceback.format_exc()

# GOOD
@app.route('/good')
def server_good():
    try:
        do_computation()
    except Exception as e:
        log(traceback.format_exc())
        return "An internal error has occurred!"

```

## References
* OWASP: [Information Leak](https://www.owasp.org/index.php/Information_Leak_(information_disclosure)).
* Common Weakness Enumeration: [CWE-209](https://cwe.mitre.org/data/definitions/209.html).
* Common Weakness Enumeration: [CWE-497](https://cwe.mitre.org/data/definitions/497.html).