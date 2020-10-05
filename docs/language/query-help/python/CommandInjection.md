# Uncontrolled command line

```
ID: py/command-line-injection
Kind: path-problem
Severity: error
Precision: high
Tags: correctness security external/owasp/owasp-a1 external/cwe/cwe-078 external/cwe/cwe-088

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/python/ql/src/Security/CWE-078/CommandInjection.ql)

Code that passes user input directly to `exec`, `eval`, or some other library routine that executes a command, allows the user to execute malicious code.


## Recommendation
If possible, use hard-coded string literals to specify the command to run or the library to load. Instead of passing the user input directly to the process or library function, examine the user input and then choose among hard-coded string literals.

If the applicable libraries or commands cannot be determined at compile time, then add code to verify that the user input string is safe before using it.


## Example
The following example shows two functions. The first is unsafe as it takes a shell script that can be changed by a user, and passes it straight to `subprocess.call()` without examining it first. The second is safe as it selects the command from a predefined allowlist.


```python

urlpatterns = [
    # Route to command_execution
    url(r'^command-ex1$', command_execution_unsafe, name='command-execution-unsafe'),
    url(r'^command-ex2$', command_execution_safe, name='command-execution-safe')
]

COMMANDS = {
    "list" :"ls",
    "stat" : "stat"
}

def command_execution_unsafe(request):
    if request.method == 'POST':
        action = request.POST.get('action', '')
        #BAD -- No sanitizing of input
        subprocess.call(["application", action])

def command_execution_safe(request):
    if request.method == 'POST':
        action = request.POST.get('action', '')
        #GOOD -- Use an allowlist
        subprocess.call(["application", COMMANDS[action]])

```

## References
* OWASP: [Command Injection](https://www.owasp.org/index.php/Command_Injection).
* Common Weakness Enumeration: [CWE-78](https://cwe.mitre.org/data/definitions/78.html).
* Common Weakness Enumeration: [CWE-88](https://cwe.mitre.org/data/definitions/88.html).