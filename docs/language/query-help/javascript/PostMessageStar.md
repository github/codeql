# Cross-window communication with unrestricted target origin

```
ID: js/cross-window-information-leak
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-201 external/cwe/cwe-359

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/javascript/ql/src/Security/CWE-201/PostMessageStar.ql)

The `window.postMessage` method allows different windows or iframes to communicate directly, even if they were loaded from different origins, circumventing the usual same-origin policy.

The sender of the message can restrict the origin of the receiver by specifying a target origin. If the receiver window does not come from this origin, the message is not sent.

Alternatively, the sender can specify a target origin of `'*'`, which means that any origin is acceptable and the message is always sent.

This feature should not be used if the message being sent contains sensitive data such as user credentials: the target window may have been loaded from a malicious site, to which the data would then become available.


## Recommendation
If possible, specify a target origin when using `window.postMessage`. Alternatively, encrypt the sensitive data before sending it to prevent an unauthorized receiver from accessing it.


## Example
The following example code sends user credentials (in this case, their user name) to `window.parent` without checking its origin. If a malicious site loads the page containing this code into an iframe it would be able to gain access to the user name.


```javascript
window.parent.postMessage(userName, '*');

```
To prevent this from happening, the origin of the target window should be restricted, as in this example:


```javascript
window.parent.postMessage(userName, 'https://lgtm.com');

```

## References
* Mozilla Developer Network: [Window.postMessage](https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage).
* Mozilla Developer Network: [Same-origin policy](https://developer.mozilla.org/en-US/docs/Web/Security/Same-origin_policy).
* Common Weakness Enumeration: [CWE-201](https://cwe.mitre.org/data/definitions/201.html).
* Common Weakness Enumeration: [CWE-359](https://cwe.mitre.org/data/definitions/359.html).