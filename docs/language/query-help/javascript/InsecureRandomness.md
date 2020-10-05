# Insecure randomness

```
ID: js/insecure-randomness
Kind: path-problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-338

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-338/InsecureRandomness.ql)

Using a cryptographically weak pseudo-random number generator to generate a security-sensitive value, such as a password, makes it easier for an attacker to predict the value.

Pseudo-random number generators generate a sequence of numbers that only approximates the properties of random numbers. The sequence is not truly random because it is completely determined by a relatively small set of initial values, the seed. If the random number generator is cryptographically weak, then this sequence may be easily predictable through outside observations.


## Recommendation
Use a cryptographically secure pseudo-random number generator if the output is to be used in a security-sensitive context. As a rule of thumb, a value should be considered "security-sensitive" if predicting it would allow the attacker to perform an action that they would otherwise be unable to perform. For example, if an attacker could predict the random password generated for a new user, they would be able to log in as that new user.

For JavaScript on the NodeJS platform, `crypto.getRandomBytes` provides a cryptographically secure pseudo-random byte generator. Note that the conversion from bytes to numbers can introduce bias that breaks the security.

For JavaScript in the browser, `RandomSource.getRandomValues` provides a cryptographically secure pseudo-random number generator.


## Example
The following examples show different ways of generating a password.

In the first case, we generate a fresh password by appending a random integer to the end of a static string. The random number generator used (`Math.random`) is not cryptographically secure, so it may be possible for an attacker to predict the generated password.


```javascript
function insecurePassword() {
    // BAD: the random suffix is not cryptographically secure
    var suffix = Math.random();
    var password = "myPassword" + suffix;
    return password;
}

```
In the second example, a cryptographically secure random number generator is used for the same purpose. In this case, it is much harder to predict the generated integers.


```javascript
function securePassword() {
    // GOOD: the random suffix is cryptographically secure
    var suffix = window.crypto.getRandomValues(new Uint32Array(1))[0];
    var password = "myPassword" + suffix;
    return password;
}

```

## References
* Wikipedia: [Pseudo-random number generator](http://en.wikipedia.org/wiki/Pseudorandom_number_generator).
* Mozilla Developer Network: [RandomSource.getRandomValues](https://developer.mozilla.org/en-US/docs/Web/API/RandomSource/getRandomValues).
* NodeJS: [crypto.randomBytes](https://nodejs.org/api/crypto.html#crypto_crypto_randombytes_size_callback)
* Common Weakness Enumeration: [CWE-338](https://cwe.mitre.org/data/definitions/338.html).