# Default version of SSL/TLS may be insecure

```
ID: py/insecure-default-protocol
Kind: problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-327

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/python/ql/src/Security/CWE-327/InsecureDefaultProtocol.ql)

The `ssl` library defaults to an insecure version of SSL/TLS when no specific protocol version is specified. This may leave the connection vulnerable to attack.


## Recommendation
Ensure that a modern, strong protocol is used. All versions of SSL, and TLS 1.0 are known to be vulnerable to attacks. Using TLS 1.1 or above is strongly recommended. If no explicit `ssl_version` is specified, the default `PROTOCOL_TLS` is chosen. This protocol is insecure and should not be used.


## Example
The following code shows two different ways of setting up a connection using SSL or TLS. They are both potentially insecure because the default version is used.


```python
import ssl
import socket

# Using the deprecated ssl.wrap_socket method
ssl.wrap_socket(socket.socket())

# Using SSLContext
context = ssl.SSLContext()

```
Both of the cases above should be updated to use a secure protocol instead, for instance by specifying `ssl_version=PROTOCOL_TLSv1_1` as a keyword argument.

Note that `ssl.wrap_socket` has been deprecated in Python 3.7. A preferred alternative is to use `ssl.SSLContext`, which is supported in Python 2.7.9 and 3.2 and later versions.


## References
* Wikipedia: [ Transport Layer Security](https://en.wikipedia.org/wiki/Transport_Layer_Security).
* Python 3 documentation: [ class ssl.SSLContext](https://docs.python.org/3/library/ssl.html#ssl.SSLContext).
* Python 3 documentation: [ ssl.wrap_socket](https://docs.python.org/3/library/ssl.html#ssl.wrap_socket).
* Common Weakness Enumeration: [CWE-327](https://cwe.mitre.org/data/definitions/327.html).