# Shell command built from environment values

```
ID: js/shell-command-injection-from-environment
Kind: path-problem
Severity: warning
Precision: high
Tags: correctness security external/cwe/cwe-078 external/cwe/cwe-088

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-078/ShellCommandInjectionFromEnvironment.ql)

Dynamically constructing a shell command with values from the local environment, such as file paths, may inadvertently change the meaning of the shell command. Such changes can occur when an environment value contains characters that the shell interprets in a special way, for instance quotes and spaces. This can result in the shell command misbehaving, or even allowing a malicious user to execute arbitrary commands on the system.


## Recommendation
If possible, use hard-coded string literals to specify the shell command to run, and provide the dynamic arguments to the shell command separately to avoid interpretation by the shell.

Alternatively, if the shell command must be constructed dynamically, then add code to ensure that special characters in environment values do not alter the shell command unexpectedly.


## Example
The following example shows a dynamically constructed shell command that recursively removes a temporary directory that is located next to the currently executing JavaScript file. Such utilities are often found in custom build scripts.


```javascript
var cp = require("child_process"),
  path = require("path");
function cleanupTemp() {
  let cmd = "rm -rf " + path.join(__dirname, "temp");
  cp.execSync(cmd); // BAD
}

```
The shell command will, however, fail to work as intended if the absolute path of the script's directory contains spaces. In that case, the shell command will interpret the absolute path as multiple paths, instead of a single path.

For instance, if the absolute path of the temporary directory is `/home/username/important project/temp`, then the shell command will recursively delete `/home/username/important` and `project/temp`, where the latter path gets resolved relative to the working directory of the JavaScript process.

Even worse, although less likely, a malicious user could provide the path `/home/username/; cat /etc/passwd #/important project/temp` in order to execute the command `cat /etc/passwd`.

To avoid such potentially catastrophic behaviors, provide the directory as an argument that does not get interpreted by a shell:


```javascript
var cp = require("child_process"),
  path = require("path");
function cleanupTemp() {
  let cmd = "rm",
    args = ["-rf", path.join(__dirname, "temp")];
  cp.execFileSync(cmd, args); // GOOD
}

```

## References
* OWASP: [Command Injection](https://www.owasp.org/index.php/Command_Injection).
* Common Weakness Enumeration: [CWE-78](https://cwe.mitre.org/data/definitions/78.html).
* Common Weakness Enumeration: [CWE-88](https://cwe.mitre.org/data/definitions/88.html).