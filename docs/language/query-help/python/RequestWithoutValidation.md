# Request without certificate validation

```
ID: py/request-without-cert-validation
Kind: problem
Severity: error
Precision: medium
Tags: security external/cwe/cwe-295

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/python/ql/src/Security/CWE-295/RequestWithoutValidation.ql)

Encryption is key to the security of most, if not all, online communication. Using Transport Layer Security (TLS) can ensure that communication cannot be interrupted by an interloper. For this reason, is is unwise to disable the verification that TLS provides. Functions in the `requests` module provide verification by default, and it is only when explicitly turned off using `verify=False` that no verification occurs.


## Recommendation
Never use `verify=False` when making a request.


## Example
The example shows two unsafe calls to [semmle.com](https://semmle.com), followed by various safe alternatives.


```python
import requests

#Unsafe requests

requests.get('https://semmle.com', verify=False) # UNSAFE
requests.get('https://semmle.com', verify=0) # UNSAFE

#Various safe options

requests.get('https://semmle.com', verify=True) # Explicitly safe
requests.get('https://semmle.com', verify="/path/to/cert/")
requests.get('https://semmle.com') # The default is to verify.

#Wrapper to ensure safety

def make_safe_request(url, verify_cert):
    if not verify_cert:
        raise Exception("Trying to make unsafe request")
    return requests.get(url, verify_cert)

```

## References
* Python requests documentation: [SSL Cert Verification](http://docs.python-requests.org/en/master/user/advanced/#ssl-cert-verification).
* Common Weakness Enumeration: [CWE-295](https://cwe.mitre.org/data/definitions/295.html).