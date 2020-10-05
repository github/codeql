# Client-side URL redirect

```
ID: js/client-side-unvalidated-url-redirection
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-079 external/cwe/cwe-116 external/cwe/cwe-601

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-601/ClientSideUrlRedirect.ql)

Redirecting to a URL that is constructed from parts of the DOM that may be controlled by an attacker can facilitate phishing attacks. In these attacks, unsuspecting users can be redirected to a malicious site that looks very similar to the real site they intend to visit, but which is controlled by the attacker.


## Recommendation
To guard against untrusted URL redirection, it is advisable to avoid putting user input directly into a redirect URL. Instead, maintain a list of authorized redirects on the server; then choose from that list based on the user input provided.


## Example
The following example uses a regular expression to extract a query parameter from the document URL, and then uses it to construct a new URL to redirect to without any further validation. This may allow an attacker to craft a link that redirects from a trusted website to some arbitrary website of their choosing, which facilitates phishing attacks:


```javascript
window.location = /.*redirect=([^&]*).*/.exec(document.location.href)[1];

```

## References
* OWASP: [ XSS Unvalidated Redirects and Forwards Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.html).
* Common Weakness Enumeration: [CWE-79](https://cwe.mitre.org/data/definitions/79.html).
* Common Weakness Enumeration: [CWE-116](https://cwe.mitre.org/data/definitions/116.html).
* Common Weakness Enumeration: [CWE-601](https://cwe.mitre.org/data/definitions/601.html).