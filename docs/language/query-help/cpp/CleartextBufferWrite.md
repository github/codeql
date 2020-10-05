# Cleartext storage of sensitive information in buffer

```
ID: cpp/cleartext-storage-buffer
Kind: path-problem
Severity: warning
Precision: medium
Tags: security external/cwe/cwe-312

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-311/CleartextBufferWrite.ql)

Sensitive information that is stored unencrypted is accessible to an attacker who gains access to the storage.


## Recommendation
Ensure that sensitive information is always encrypted before being stored, especially before writing to a file. It may be wise to encrypt information before it is put into a buffer that may be readable in memory.

In general, decrypt sensitive information only at the point where it is necessary for it to be used in cleartext.


## Example
The following example shows two ways of storing user credentials in a file. In the 'BAD' case, the credentials are simply stored in cleartext. In the 'GOOD' case, the credentials are encrypted before storing them.


```c
void writeCredentials() {
  char *password = "cleartext password";
  FILE* file = fopen("credentials.txt", "w");
  
  // BAD: write password to disk in cleartext
  fputs(password, file);
  
  // GOOD: encrypt password first
  char *encrypted = encrypt(password);
  fputs(encrypted, file);
}


```

## References
* M. Dowd, J. McDonald and J. Schuhm, *The Art of Software Security Assessment*, 1st Edition, Chapter 2 - 'Common Vulnerabilities of Encryption', p. 43. Addison Wesley, 2006.
* M. Howard and D. LeBlanc, *Writing Secure Code*, 2nd Edition, Chapter 9 - 'Protecting Secret Data', p. 299. Microsoft, 2002.
* Common Weakness Enumeration: [CWE-312](https://cwe.mitre.org/data/definitions/312.html).