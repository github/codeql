# Code injection

```
ID: py/code-injection
Kind: path-problem
Severity: error
Precision: high
Tags: security external/owasp/owasp-a1 external/cwe/cwe-094 external/cwe/cwe-095 external/cwe/cwe-116

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/python/ql/src/Security/CWE-094/CodeInjection.ql)

Directly evaluating user input (for example, an HTTP request parameter) as code without properly sanitizing the input first allows an attacker arbitrary code execution. This can occur when user input is passed to code that interprets it as an expression to be evaluated, such as `eval` or `exec`.


## Recommendation
Avoid including user input in any expression that may be dynamically evaluated. If user input must be included, use context-specific escaping before including it. It is important that the correct escaping is used for the type of evaluation that will occur.


## Example
The following example shows two functions setting a name from a request. The first function uses `exec` to execute the `setname` function. This is dangerous as it can allow a malicious user to execute arbitrary code on the server. For example, the user could supply the value `"' + subprocess.call('rm -rf') + '"` to destroy the server's file system. The second function calls the `setname` function directly and is thus safe.


```python

urlpatterns = [
    # Route to code_execution
    url(r'^code-ex1$', code_execution_bad, name='code-execution-bad'),
    url(r'^code-ex2$', code_execution_good, name='code-execution-good')
]

def code_execution(request):
    if request.method == 'POST':
        first_name = base64.decodestring(request.POST.get('first_name', ''))
        #BAD -- Allow user to define code to be run.
        exec("setname('%s')" % first_name)

def code_execution(request):
    if request.method == 'POST':
        first_name = base64.decodestring(request.POST.get('first_name', ''))
        #GOOD --Call code directly
        setname(first_name)

```

## References
* OWASP: [Code Injection](https://www.owasp.org/index.php/Code_Injection).
* Wikipedia: [Code Injection](https://en.wikipedia.org/wiki/Code_injection).
* Common Weakness Enumeration: [CWE-94](https://cwe.mitre.org/data/definitions/94.html).
* Common Weakness Enumeration: [CWE-95](https://cwe.mitre.org/data/definitions/95.html).
* Common Weakness Enumeration: [CWE-116](https://cwe.mitre.org/data/definitions/116.html).