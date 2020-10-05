# Creating biased random numbers from a cryptographically secure source.

```
ID: js/biased-cryptographic-random
Kind: problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-327

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-327/BadRandomness.ql)

Generating secure random numbers can be an important part of creating a secure software system. This can be done using APIs that create cryptographically secure random numbers.

However, using some mathematical operations on these cryptographically secure random numbers can create biased results, where some outcomes are more likely than others. Such biased results can make it easier for an attacker to guess the random numbers, and thereby break the security of the software system.


## Recommendation
Be very careful not to introduce bias when performing mathematical operations on cryptographically secure random numbers.

If possible, avoid performing mathematical operations on cryptographically secure random numbers at all, and use a preexisting library instead.


## Example
The example below uses the modulo operator to create an array of 10 random digits using random bytes as the source for randomness.


```javascript
const crypto = require('crypto');

const digits = [];
for (let i = 0; i < 10; i++) {
    digits.push(crypto.randomBytes(1)[0] % 10); // NOT OK
}
```
The random byte is a uniformly random value between 0 and 255, and thus the result from using the modulo operator is slightly more likely to be between 0 and 5 than between 6 and 9.

The issue has been fixed in the code below by using a library that correctly generates cryptographically secure random values.


```javascript
const cryptoRandomString = require('crypto-random-string');

const digits = cryptoRandomString({length: 10, type: 'numeric'});
```
Alternatively, the issue can be fixed by fixing the math in the original code. In the code below the random byte is discarded if the value is greater than or equal to 250. Thus the modulo operator is used on a uniformly random number between 0 and 249, which results in a uniformly random digit between 0 and 9.


```javascript
const crypto = require('crypto');

const digits = [];
while (digits.length < 10) {
    const byte = crypto.randomBytes(1)[0];
    if (byte >= 250) {
        continue;
    }
    digits.push(byte % 10); // OK
}
```

## References
* Stack Overflow: [Understanding “randomness”](https://stackoverflow.com/questions/3956478/understanding-randomness).
* OWASP: [Insecure Randomness](https://owasp.org/www-community/vulnerabilities/Insecure_Randomness).
* OWASP: [Rule - Use strong approved cryptographic algorithms](https://cheatsheetseries.owasp.org/cheatsheets/Cryptographic_Storage_Cheat_Sheet.html#rule---use-strong-approved-authenticated-encryption).
* Common Weakness Enumeration: [CWE-327](https://cwe.mitre.org/data/definitions/327.html).