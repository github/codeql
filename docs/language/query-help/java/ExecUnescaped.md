# Building a command line with string concatenation

```
ID: java/concatenated-command-line
Kind: problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-078 external/cwe/cwe-088

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/java/ql/src/Security/CWE/CWE-078/ExecUnescaped.ql)

Code that builds a command line by concatenating strings that have been entered by a user allows the user to execute malicious code.


## Recommendation
Execute external commands using an array of strings rather than a single string. By using an array, many possible vulnerabilities in the formatting of the string are avoided.


## Example
In the following example, `latlonCoords` contains a string that has been entered by a user but not validated by the program. This allows the user to, for example, append an ampersand (&) followed by the command for a malicious program to the end of the string. The ampersand instructs Windows to execute another program. In the block marked 'BAD', `latlonCoords` is passed to `exec` as part of a concatenated string, which allows more than one command to be executed. However, in the block marked 'GOOD', `latlonCoords` is passed as part of an array, which means that `exec` treats it only as an argument.


```java
class Test {
    public static void main(String[] args) {
        // BAD: user input might include special characters such as ampersands
        {
            String latlonCoords = args[1];
            Runtime rt = Runtime.getRuntime();
            Process exec = rt.exec("cmd.exe /C latlon2utm.exe " + latlonCoords);
        }

        // GOOD: use an array of arguments instead of executing a string
        {
            String latlonCoords = args[1];
            Runtime rt = Runtime.getRuntime();
            Process exec = rt.exec(new String[] {
                    "c:\\path\to\latlon2utm.exe",
                    latlonCoords });
        }
    }
}

```

## References
* OWASP: [Command Injection](https://www.owasp.org/index.php/Command_Injection).
* The CERT Oracle Secure Coding Standard for Java: [IDS07-J. Sanitize untrusted data passed to the Runtime.exec() method](https://www.securecoding.cert.org/confluence/display/java/IDS07-J.+Sanitize+untrusted+data+passed+to+the+Runtime.exec%28%29+method).
* Common Weakness Enumeration: [CWE-78](https://cwe.mitre.org/data/definitions/78.html).
* Common Weakness Enumeration: [CWE-88](https://cwe.mitre.org/data/definitions/88.html).