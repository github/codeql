# Improper code sanitization

```
ID: js/bad-code-sanitization
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-094 external/cwe/cwe-079 external/cwe/cwe-116

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-094/ImproperCodeSanitization.ql)

Using string concatenation to construct JavaScript code can be error-prone, or in the worst case, enable code injection if an input is constructed by an attacker.


## Recommendation
If using `JSON.stringify` or a HTML sanitizer to sanitize a string inserted into JavaScript code, then make sure to perform additional sanitization or remove potentially dangerous characters.


## Example
The example below constructs a function that assigns the number 42 to the property `key` on an object `obj`. However, if `key` contains `</script>`, then the generated code will break out of a `</script>` if inserted into a `</script>` tag.


```javascript
function createObjectWrite() {
    const assignment = `obj[${JSON.stringify(key)}]=42`;
    return `(function(){${assignment}})` // NOT OK
}
```
The issue has been fixed by escaping potentially dangerous characters, as shown below.


```javascript
const charMap = {
    '<': '\\u003C',
    '>' : '\\u003E',
    '/': '\\u002F',
    '\\': '\\\\',
    '\b': '\\b',
    '\f': '\\f',
    '\n': '\\n',
    '\r': '\\r',
    '\t': '\\t',
    '\0': '\\0',
    '\u2028': '\\u2028',
    '\u2029': '\\u2029'
};

function escapeUnsafeChars(str) {
    return str.replace(/[<>\b\f\n\r\t\0\u2028\u2029]/g, x => charMap[x])
}

function createObjectWrite() {
    const assignment = `obj[${escapeUnsafeChars(JSON.stringify(key))}]=42`;
    return `(function(){${assignment}})` // OK
}
```

## References
* OWASP: [Code Injection](https://www.owasp.org/index.php/Code_Injection).
* Common Weakness Enumeration: [CWE-94](https://cwe.mitre.org/data/definitions/94.html).
* Common Weakness Enumeration: [CWE-79](https://cwe.mitre.org/data/definitions/79.html).
* Common Weakness Enumeration: [CWE-116](https://cwe.mitre.org/data/definitions/116.html).