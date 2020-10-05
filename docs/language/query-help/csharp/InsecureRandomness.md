# Insecure randomness

```
ID: cs/insecure-randomness
Kind: path-problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-338

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Security%20Features/InsecureRandomness.ql)

Using a cryptographically weak pseudo-random number generator to generate a security-sensitive value, such as a password, makes it easier for an attacker to predict the value.

Pseudo-random number generators generate a sequence of numbers that only approximates the properties of random numbers. The sequence is not truly random because it is completely determined by a relatively small set of initial values, the seed. If the random number generator is cryptographically weak, then this sequence may be easily predictable through outside observations.


## Recommendation
Use a cryptographically secure pseudo-random number generator if the output is to be used in a security sensitive context. As a rule of thumb, a value should be considered "security sensitive" if predicting it would allow the attacker to perform an action that they would otherwise be unable to perform. For example, if an attacker could predict the random password generated for a new user, they would be able to log in as that new user.

For C#, `RNGCryptoServiceProvider` provides a cryptographically secure pseudo-random number generator. `Random` is not cryptographically secure, and should be avoided in security contexts. For contexts which are not security sensitive, `Random` may be preferable as it has a more convenient interface, and is likely to be faster.

For the specific use-case of generating passwords, consider `System.Web.Security.Membership.GeneratePassword`, which provides a cryptographically secure method of generating random passwords.


## Example
The following examples show different ways of generating a password.

In the first case, we generate a fresh password by appending a random integer to the end of a static string. The random number generator used (`Random`) is not cryptographically secure, so it may be possible for an attacker to predict the generated password.

In the second example, a cryptographically secure random number generator is used for the same purpose. In this case, it is much harder to predict the generated integers.

In the final example, the password is generated using the `Membership.GeneratePassword` library method, which uses a cryptographically secure random number generator to generate a random series of characters. This method should be preferred when generating passwords, if possible, as it avoids potential pitfalls when converting the output of a random number generator (usually an int or a byte) to a series of permitted characters.


```csharp
using System.Security.Cryptography;
using System.Web.Security;

string GeneratePassword()
{
    // BAD: Password is generated using a cryptographically insecure RNG
    Random gen = new Random();
    string password = "mypassword" + gen.Next();

    // GOOD: Password is generated using a cryptographically secure RNG
    using (RNGCryptoServiceProvider crypto = new RNGCryptoServiceProvider())
    {
        byte[] randomBytes = new byte[sizeof(int)];
        crypto.GetBytes(randomBytes);
        password = "mypassword" + BitConverter.ToInt32(randomBytes);
    }

    // GOOD: Password is generated using a cryptographically secure RNG
    password = Membership.GeneratePassword(12, 3);

    return password;
}

```

## References
* Wikipedia. [Pseudo-random number generator](http://en.wikipedia.org/wiki/Pseudorandom_number_generator).
* MSDN. [RandomNumberGenerator](http://msdn.microsoft.com/en-us/library/system.security.cryptography.randomnumbergenerator.aspx).
* MSDN. [Membership.GeneratePassword](https://msdn.microsoft.com/en-us/library/system.web.security.membership.generatepassword(v=vs.110).aspx).
* Common Weakness Enumeration: [CWE-338](https://cwe.mitre.org/data/definitions/338.html).