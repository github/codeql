# Use of a broken or weak cryptographic algorithm

```
ID: py/weak-cryptographic-algorithm
Kind: path-problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-327

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/python/ql/src/Security/CWE-327/BrokenCryptoAlgorithm.ql)

Using broken or weak cryptographic algorithms can leave data vulnerable to being decrypted or forged by an attacker.

Many cryptographic algorithms provided by cryptography libraries are known to be weak, or flawed. Using such an algorithm means that encrypted or hashed data is less secure than it appears to be.


## Recommendation
Ensure that you use a strong, modern cryptographic algorithm. Use at least AES-128 or RSA-2048 for encryption, and SHA-2 or SHA-3 for secure hashing.


## Example
The following code uses the `pycrypto` library to encrypt some secret data. When you create a cipher using `pycrypto` you must specify the encryption algorithm to use. The first example uses DES, which is an older algorithm that is now considered weak. The second example uses Blowfish, which is a stronger more modern algorithm.


```python
from Crypto.Cipher import DES, Blowfish

cipher = DES.new(SECRET_KEY)

def send_encrypted(channel, message):
    channel.send(cipher.encrypt(message)) # BAD: weak encryption


cipher = Blowfish.new(SECRET_KEY)

def send_encrypted(channel, message):
    channel.send(cipher.encrypt(message)) # GOOD: strong encryption


```
WARNING: Although the second example above is more robust, pycrypto is no longer actively maintained so we recommend using `cryptography` instead.


## References
* NIST, FIPS 140 Annex a: [ Approved Security Functions](http://csrc.nist.gov/publications/fips/fips140-2/fips1402annexa.pdf).
* NIST, SP 800-131A: [ Transitions: Recommendation for Transitioning the Use of Cryptographic Algorithms and Key Lengths](http://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-131Ar1.pdf).
* OWASP: [Rule - Use strong approved cryptographic algorithms](https://cheatsheetseries.owasp.org/cheatsheets/Cryptographic_Storage_Cheat_Sheet.html#rule---use-strong-approved-authenticated-encryption).
* Common Weakness Enumeration: [CWE-327](https://cwe.mitre.org/data/definitions/327.html).