# Use of insecure SSL/TLS version

```
ID: py/insecure-protocol
Kind: problem
Severity: warning
Precision: high
Tags: security external/cwe/cwe-327

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/python/ql/src/Security/CWE-327/InsecureProtocol.ql)

Using a broken or weak cryptographic protocol may make a connection vulnerable to interference from an attacker.


## Recommendation
Ensure that a modern, strong protocol is used. All versions of SSL, and TLS 1.0 are known to be vulnerable to attacks. Using TLS 1.1 or above is strongly recommended.


## Example
The following code shows a variety of ways of setting up a connection using SSL or TLS. They are all insecure because of the version specified.


```python
import ssl
import socket

# Using the deprecated ssl.wrap_socket method
ssl.wrap_socket(socket.socket(), ssl_version=ssl.PROTOCOL_SSLv2)

# Using SSLContext
context = ssl.SSLContext(ssl_version=ssl.PROTOCOL_SSLv3)

# Using pyOpenSSL

from pyOpenSSL import SSL

context = SSL.Context(SSL.TLSv1_METHOD)



```
All cases should be updated to use a secure protocol, such as `PROTOCOL_TLSv1_1`.

Note that `ssl.wrap_socket` has been deprecated in Python 3.7. A preferred alternative is to use `ssl.SSLContext`, which is supported in Python 2.7.9 and 3.2 and later versions.


## References
* Wikipedia: [ Transport Layer Security](https://en.wikipedia.org/wiki/Transport_Layer_Security).
* Python 3 documentation: [ class ssl.SSLContext](https://docs.python.org/3/library/ssl.html#ssl.SSLContext).
* Python 3 documentation: [ ssl.wrap_socket](https://docs.python.org/3/library/ssl.html#ssl.wrap_socket).
* pyOpenSSL documentation: [ An interface to the SSL-specific parts of OpenSSL](https://pyopenssl.org/en/stable/api/ssl.html).
* Common Weakness Enumeration: [CWE-327](https://cwe.mitre.org/data/definitions/327.html).