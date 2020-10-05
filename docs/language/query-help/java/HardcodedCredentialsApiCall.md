# Hard-coded credential in API call

```
ID: java/hardcoded-credential-api-call
Kind: path-problem
Severity: error
Precision: medium
Tags: security external/cwe/cwe-798

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/java/ql/src/Security/CWE/CWE-798/HardcodedCredentialsApiCall.ql)

Including unencrypted hard-coded authentication credentials in source code is dangerous because the credentials may be easily discovered. For example, the code may be open source, or it may be leaked or accidentally revealed, making the credentials visible to an attacker. This, in turn, might enable them to gain unauthorized access, or to obtain privileged information.


## Recommendation
Remove hard-coded credentials, such as user names, passwords and certificates, from source code. Instead, place them in configuration files, environment variables or other data stores if necessary. If possible, store configuration files including credential data separately from the source code, in a secure location with restricted access.


## Example
The following code example connects to a database using a hard-coded user name and password:


```java
private static final String p = "123456"; // hard-coded credential

public static void main(String[] args) throws SQLException {
    String url = "jdbc:mysql://localhost/test";
    String u = "admin"; // hard-coded credential

    getConn(url, u, p);
}

public static void getConn(String url, String v, String q) throws SQLException {
    DriverManager.getConnection(url, v, q); // sensitive call
}

```
Instead, the user name and password could be supplied through environment variables, which can be set externally without hard-coding credentials in the source code.


## References
* OWASP: [Use of hard-coded password](https://www.owasp.org/index.php/Use_of_hard-coded_password).
* Common Weakness Enumeration: [CWE-798](https://cwe.mitre.org/data/definitions/798.html).