# Weak encryption

```
ID: cs/weak-encryption
Kind: problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-327

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/WeakEncryption.ql)

Weak encryption algorithms provide very little security. For example DES encryption uses keys of 56 bits only, and no longer provides sufficient protection for sensitive data. TripleDES should also be deprecated for very sensitive data: Although it improves on DES by using 168-bit long keys, it provides in fact at most 112 bits of security.


## Recommendation
You should switch to a more secure encryption algorithm, such as AES (Advanced Encryption Standard) and use a key length which is reasonable for the application for which it is being used.


## Example
This example uses DES, which is limited to a 56-bit key. The key provided is actually 64 bits but the last bit of each byte is turned into a parity bit. For example the bytes 01010101 and 01010100 can be used in place of each other when encrypting and decrypting.


```csharp
class WeakEncryption
{
    public static byte[] encryptString()
    {
        SymmetricAlgorithm serviceProvider = new DESCryptoServiceProvider();
        byte[] key = { 16, 22, 240, 11, 18, 150, 192, 21 };
        serviceProvider.Key = key;
        ICryptoTransform encryptor = serviceProvider.CreateEncryptor();

        String message = "Hello World";
        byte[] messageB = System.Text.Encoding.ASCII.GetBytes(message);
        return encryptor.TransformFinalBlock(messageB, 0, messageB.Length);
    }
}

```

## References
* Wikipedia: [Key Size](http://en.wikipedia.org/wiki/Key_size)
* Wikipedia: [DES](http://en.wikipedia.org/wiki/Data_Encryption_Standard)
* Common Weakness Enumeration: [CWE-327](https://cwe.mitre.org/data/definitions/327.html).