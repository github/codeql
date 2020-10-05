# Use of password hash with insufficient computational effort

```
ID: js/insufficient-password-hash
Kind: path-problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-916

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-916/InsufficientPasswordHash.ql)

Storing cryptographic hashes of passwords is standard security practice, but it is equally important to select the right hashing scheme. If an attacker obtains the hashed passwords of an application, the password hashing scheme should still prevent the attacker from easily obtaining the original cleartext passwords.

A good password hashing scheme requires a computation that cannot be done efficiently. Standard hashing schemes, such as `md5` or `sha1`, are efficiently computable, and are therefore not suitable for password hashing.


## Recommendation
Use a secure password hashing scheme such as `bcrypt`, `scrypt`, `PBKDF2`, or `Argon2`.


## Example
In the example below, the `md5` algorithm computes the hash of a password.


```javascript
const crypto = require("crypto");
function hashPassword(password) {
    var hasher = crypto.createHash('md5');
    var hashed = hasher.update(password).digest("hex"); // BAD
    return hashed;
}

```
This is not secure, since the password can be efficiently cracked by an attacker that obtains the hash. A more secure scheme is to hash the password with the `bcrypt` algorithm:


```javascript
const bcrypt = require("bcrypt");
function hashPassword(password, salt) {
  var hashed = bcrypt.hashSync(password, salt); // GOOD
  return hashed;
}

```

## References
* OWASP: [Password storage](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html).
* Common Weakness Enumeration: [CWE-916](https://cwe.mitre.org/data/definitions/916.html).