# Use of a potentially broken or risky cryptographic algorithm

```
ID: java/potentially-weak-cryptographic-algorithm
Kind: path-problem
Severity: warning
Precision: medium
Tags: security external/cwe/cwe-327

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/java/ql/src/Security/CWE/CWE-327/MaybeBrokenCryptoAlgorithm.ql)

Using broken or weak cryptographic algorithms can leave data vulnerable to being decrypted.

Many cryptographic algorithms provided by cryptography libraries are known to be weak, or flawed. Using such an algorithm means that an attacker may be able to easily decrypt the encrypted data.


## Recommendation
Ensure that you use a strong, modern cryptographic algorithm. Use at least AES-128 or RSA-2048.


## Example
The following code shows an example of using a java `Cipher` to encrypt some data. When creating a `Cipher` instance, you must specify the encryption algorithm to use. The first example uses DES, which is an older algorithm that is now considered weak. The second example uses AES, which is a strong modern algorithm.


```java
// BAD: DES is a weak algorithm 
Cipher des = Cipher.getInstance("DES");
cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec);

byte[] encrypted = cipher.doFinal(input.getBytes("UTF-8"));

// ...

// GOOD: AES is a strong algorithm
Cipher des = Cipher.getInstance("AES");

// ...
```

## References
* NIST, FIPS 140 Annex a: [ Approved Security Functions](http://csrc.nist.gov/publications/fips/fips140-2/fips1402annexa.pdf).
* NIST, SP 800-131A: [ Transitions: Recommendation for Transitioning the Use of Cryptographic Algorithms and Key Lengths](http://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-131Ar1.pdf).
* Common Weakness Enumeration: [CWE-327](https://cwe.mitre.org/data/definitions/327.html).