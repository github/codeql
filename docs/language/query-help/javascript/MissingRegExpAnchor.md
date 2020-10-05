# Missing regular expression anchor

```
ID: js/regex/missing-regexp-anchor
Kind: problem
Severity: warning
Precision: medium
Tags: correctness security external/cwe/cwe-20

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-020/MissingRegExpAnchor.ql)

Sanitizing untrusted input with regular expressions is a common technique. However, it is error-prone to match untrusted input against regular expressions without anchors such as `^` or `$`. Malicious input can bypass such security checks by embedding one of the allowed patterns in an unexpected location.

Even if the matching is not done in a security-critical context, it may still cause undesirable behavior when the regular expression accidentally matches.


## Recommendation
Use anchors to ensure that regular expressions match at the expected locations.


## Example
The following example code checks that a URL redirection will reach the `example.com` domain, or one of its subdomains, and not some malicious site.


```javascript
app.get("/some/path", function(req, res) {
    let url = req.param("url");
    // BAD: the host of `url` may be controlled by an attacker
    if (url.match(/https?:\/\/www\.example\.com\//)) {
        res.redirect(url);
    }
});

```
The check with the regular expression match is, however, easy to bypass. For example by embedding `http://example.com/` in the query string component: `http://evil-example.net/?x=http://example.com/`. Address these shortcomings by using anchors in the regular expression instead:


```javascript
app.get("/some/path", function(req, res) {
    let url = req.param("url");
    // GOOD: the host of `url` can not be controlled by an attacker
    if (url.match(/^https?:\/\/www\.example\.com\//)) {
        res.redirect(url);
    }
});

```
A related mistake is to write a regular expression with multiple alternatives, but to only include an anchor for one of the alternatives. As an example, the regular expression `/^www\.example\.com|beta\.example\.com/` will match the host `evil.beta.example.com` because the regular expression is parsed as `/(^www\.example\.com)|(beta\.example\.com)/`


## References
* MDN: [Regular Expressions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions)
* OWASP: [SSRF](https://www.owasp.org/index.php/Server_Side_Request_Forgery)
* OWASP: [XSS Unvalidated Redirects and Forwards Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.html).
* Common Weakness Enumeration: [CWE-20](https://cwe.mitre.org/data/definitions/20.html).