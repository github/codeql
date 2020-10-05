# Binding a socket to all network interfaces

```
ID: py/bind-socket-all-network-interfaces
Kind: problem
Severity: error
Precision: high
Tags: security

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/python/ql/src/Security/CVE-2018-1281/BindToAllInterfaces.ql)

Sockets can be used to communicate with other machines on a network. You can use the (IP address, port) pair to define the access restrictions for the socket you create. When using the built-in Python `socket` module (for instance, when building a message sender service or an FTP server data transmitter), one has to bind the port to some interface. When you bind the port to all interfaces using `0.0.0.0` as the IP address, you essentially allow it to accept connections from any IPv4 address provided that it can get to the socket via routing. Binding to all interfaces is therefore associated with security risks.


## Recommendation
Bind your service incoming traffic only to a dedicated interface. If you need to bind more than one interface using the built-in `socket` module, create multiple sockets (instead of binding to one socket to all interfaces).


## Example
In this example, two sockets are insecure because they are bound to all interfaces; one through the `0.0.0.0` notation and another one through an empty string `''`.


```python
import socket

# binds to all interfaces, insecure
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind(('0.0.0.0', 31137))

# binds to all interfaces, insecure
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind(('', 4040))

# binds only to a dedicated interface, secure
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind(('84.68.10.12', 8080))

```

## References
* Python reference: [ Socket families](https://docs.python.org/3/library/socket.html#socket-families).
* Python reference: [ Socket Programming HOWTO](https://docs.python.org/3.7/howto/sockets.html).
* Common Vulnerabilities and Exposures: [ CVE-2018-1281 Detail](https://nvd.nist.gov/vuln/detail/CVE-2018-1281).