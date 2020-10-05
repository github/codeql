# Use of a broken or risky cryptographic algorithm

```
ID: cpp/weak-cryptographic-algorithm
Kind: problem
Severity: error
Precision: medium
Tags: security external/cwe/cwe-327

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-327/BrokenCryptoAlgorithm.ql)

Using broken or weak cryptographic algorithms can leave data vulnerable to being decrypted.

Many cryptographic algorithms provided by cryptography libraries are known to be weak, or flawed. Using such an algorithm means that an attacker may be able to easily decrypt the encrypted data.


## Recommendation
Ensure that you use a strong, modern cryptographic algorithm. Use at least AES-128 or RSA-2048.


## Example
The following code shows an example of using the `advapi` windows API to decrypt some data. When creating a key, you must specify which algorithm to use. The first example uses DES which is an older algorithm that is now considered weak. The second example uses AES, which is a strong modern algorithm.


```c
void advapi() {
  HCRYPTPROV hCryptProv;
  HCRYPTKEY hKey;
  HCRYPTHASH hHash;
  // other preparation goes here

  // BAD: use 3DES for key
  CryptDeriveKey(hCryptProv, CALG_3DES, hHash, 0, &hKey);

  // GOOD: use AES
  CryptDeriveKey(hCryptProv, CALG_AES_256, hHash, 0, &hKey);
}


```

## References
* NIST, FIPS 140 Annex a: [ Approved Security Functions](http://csrc.nist.gov/publications/fips/fips140-2/fips1402annexa.pdf).
* NIST, SP 800-131A: [ Transitions: Recommendation for Transitioning the Use of Cryptographic Algorithms and Key Lengths](http://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-131Ar1.pdf).
* Common Weakness Enumeration: [CWE-327](https://cwe.mitre.org/data/definitions/327.html).