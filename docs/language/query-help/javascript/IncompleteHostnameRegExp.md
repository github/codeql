# Incomplete regular expression for hostnames

```
ID: js/incomplete-hostname-regexp
Kind: problem
Severity: warning
Precision: high
Tags: correctness security external/cwe/cwe-20

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-020/IncompleteHostnameRegExp.ql)

Sanitizing untrusted URLs is an important technique for preventing attacks such as request forgeries and malicious redirections. Often, this is done by checking that the host of a URL is in a set of allowed hosts.

If a regular expression implements such a check, it is easy to accidentally make the check too permissive by not escaping the `.` meta-characters appropriately. Even if the check is not used in a security-critical context, the incomplete check may still cause undesirable behaviors when it accidentally succeeds.


## Recommendation
Escape all meta-characters appropriately when constructing regular expressions for security checks, pay special attention to the `.` meta-character.


## Example
The following example code checks that a URL redirection will reach the `example.com` domain, or one of its subdomains.


```javascript
app.get('/some/path', function(req, res) {
    let url = req.param('url'),
        host = urlLib.parse(url).host;
    // BAD: the host of `url` may be controlled by an attacker
    let regex = /^((www|beta).)?example.com/;
    if (host.match(regex)) {
        res.redirect(url);
    }
});

```
The check is however easy to bypass because the unescaped `.` allows for any character before `example.com`, effectively allowing the redirect to go to an attacker-controlled domain such as `wwwXexample.com`.

Address this vulnerability by escaping `.` appropriately: `let regex = /((www|beta)\.)?example\.com/`.


## References
* MDN: [Regular Expressions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions)
* OWASP: [SSRF](https://www.owasp.org/index.php/Server_Side_Request_Forgery)
* OWASP: [XSS Unvalidated Redirects and Forwards Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.html).
* Common Weakness Enumeration: [CWE-20](https://cwe.mitre.org/data/definitions/20.html).