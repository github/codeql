# Cast from char* to wchar_t*

```
ID: cpp/incorrect-string-type-conversion
Kind: problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-704 external/microsoft/c/c6276

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-704/WcharCharConversion.ql)

This rule indicates a potentially incorrect cast from an byte string (`char *`) to a wide-character string (`wchar_t *`).

This cast might yield strings that are not correctly terminated; including potential buffer overruns when using such strings with some dangerous APIs.


## Recommendation
Do not explicitly cast byte strings to wide-character strings.

For string literals, prepend the literal string with the letter "L" to indicate that the string is a wide-character string (`wchar_t *`).

For converting a byte literal to a wide-character string literal, you would need to use the appropriate conversion function for the platform you are using. Please see the references section for options according to your platform.


## Example
In the following example, an byte string literal (`"a"`) is cast to a wide-character string.


```cpp
wchar_t* pSrc;

pSrc = (wchar_t*)"a"; // casting a byte-string literal "a" to a wide-character string
```
To fix this issue, prepend the literal with the letter "L" (`L"a"`) to define it as a wide-character string.


## References
* General resources: [std::mbstowcs](https://en.cppreference.com/w/cpp/string/multibyte/mbstowcs)
* Microsoft specific resources: [Security Considerations: International Features](https://docs.microsoft.com/en-us/windows/desktop/Intl/security-considerations--international-features)
* Common Weakness Enumeration: [CWE-704](https://cwe.mitre.org/data/definitions/704.html).