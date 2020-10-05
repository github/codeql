# Use of a broken or weak cryptographic algorithm

```
ID: js/weak-cryptographic-algorithm
Kind: path-problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-327

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-327/BrokenCryptoAlgorithm.ql)

Using broken or weak cryptographic algorithms can leave data vulnerable to being decrypted or forged by an attacker.

Many cryptographic algorithms provided by cryptography libraries are known to be weak, or flawed. Using such an algorithm means that encrypted or hashed data is less secure than it appears to be.


## Recommendation
Ensure that you use a strong, modern cryptographic algorithm. Use at least AES-128 or RSA-2048 for encryption, and SHA-2 or SHA-3 for secure hashing.


## Example
The following code shows an example of using the builtin cryptographic library of NodeJS to encrypt some secret data. When creating a `Cipher` instance to encrypt the secret data with, you must specify the encryption algorithm to use. The first example uses DES, which is an older algorithm that is now considered weak. The second example uses AES, which is a strong modern algorithm.


```javascript
const crypto = require('crypto');

var secretText = obj.getSecretText();

const desCipher = crypto.createCipher('des', key);
let desEncrypted = desCipher.write(secretText, 'utf8', 'hex'); // BAD: weak encryption

const aesCipher = crypto.createCipher('aes-128', key);
let aesEncrypted = aesCipher.update(secretText, 'utf8', 'hex'); // GOOD: strong encryption

```

## References
* NIST, FIPS 140 Annex a: [ Approved Security Functions](http://csrc.nist.gov/publications/fips/fips140-2/fips1402annexa.pdf).
* NIST, SP 800-131A: [ Transitions: Recommendation for Transitioning the Use of Cryptographic Algorithms and Key Lengths](http://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-131Ar1.pdf).
* OWASP: [Rule - Use strong approved cryptographic algorithms](https://cheatsheetseries.owasp.org/cheatsheets/Cryptographic_Storage_Cheat_Sheet.html#rule---use-strong-approved-authenticated-encryption).
* Common Weakness Enumeration: [CWE-327](https://cwe.mitre.org/data/definitions/327.html).