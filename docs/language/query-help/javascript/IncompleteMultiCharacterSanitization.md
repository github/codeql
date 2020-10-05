# Incomplete multi-character sanitization

```
ID: js/incomplete-multi-character-sanitization
Kind: problem
Severity: warning
Precision: high
Tags: correctness security external/cwe/cwe-116 external/cwe/cwe-20

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-116/IncompleteMultiCharacterSanitization.ql)

Sanitizing untrusted input is an important technique for preventing injection attacks such as SQL injection or cross-site scripting. Usually, this is done by escaping meta-characters such as quotes in a domain-specific way so that they are treated as normal characters.

However, directly using the string `replace` method to perform escaping is notoriously error-prone. Common mistakes include only replacing the first occurrence of a meta-character, or backslash-escaping various meta-characters but not the backslash itself.

In the former case, later meta-characters are left undisturbed and can be used to subvert the sanitization. In the latter case, preceding a meta-character with a backslash leads to the backslash being escaped, but the meta-character appearing un-escaped, which again makes the sanitization ineffective.

Even if the escaped string is not used in a security-critical context, incomplete escaping may still have undesirable effects, such as badly rendered or confusing output.


## Recommendation
Use a (well-tested) sanitization library if at all possible. These libraries are much more likely to handle corner cases correctly than a custom implementation.

Otherwise, make sure to use a regular expression with the `g` flag to ensure that all occurrences are replaced, and remember to escape backslashes if applicable.

Note, however, that this is generally *not* sufficient for replacing multi-character strings: the `String.prototype.replace` method only performs one pass over the input string, and will not replace further instances of the string that result from earlier replacements.

For example, consider the code snippet `s.replace(/\/\.\.\//g, "")`, which attempts to strip out all occurences of `/../` from `s`. This will not work as expected: for the string `/./.././`, for example, it will remove the single occurrence of `/../` in the middle, but the remainder of the string then becomes `/../`, which is another instance of the substring we were trying to remove.


## Example
For example, assume that we want to embed a user-controlled string `accountNumber` into a SQL query as part of a string literal. To avoid SQL injection, we need to ensure that the string does not contain un-escaped single-quote characters. The following function attempts to ensure this by doubling single quotes, and thereby escaping them:


```javascript
function escapeQuotes(s) {
  return s.replace("'", "''");
}

```
As written, this sanitizer is ineffective: if the first argument to `replace` is a string literal (as in this case), only the *first* occurrence of that string is replaced.

As mentioned above, the function `escapeQuotes` should be replaced with a purpose-built sanitization library, such as the npm module `sqlstring`. Many other sanitization libraries are available from npm and other sources.

If this is not an option, `escapeQuotes` should be rewritten to use a regular expression with the `g` ("global") flag instead:


```javascript
function escapeQuotes(s) {
  return s.replace(/'/g, "''");
}

```
Note that it is very important to include the global flag: `s.replace(/'/, "''")` *without* the global flag is equivalent to the first example above and only replaces the first quote.


## References
* OWASP Top 10: [A1 Injection](https://www.owasp.org/index.php/Top_10-2017_A1-Injection).
* npm: [sqlstring](https://www.npmjs.com/package/sqlstring) package.
* Common Weakness Enumeration: [CWE-116](https://cwe.mitre.org/data/definitions/116.html).
* Common Weakness Enumeration: [CWE-20](https://cwe.mitre.org/data/definitions/20.html).