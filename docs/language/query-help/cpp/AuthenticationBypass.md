# Authentication bypass by spoofing

```
ID: cpp/user-controlled-bypass
Kind: path-problem
Severity: warning
Precision: medium
Tags: security external/cwe/cwe-290

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-290/AuthenticationBypass.ql)

Code which relies on an IP address or domain name for authentication can be exploited by an attacker who spoofs their address.


## Recommendation
IP address verification can be a useful part of an authentication scheme, but it should not be the single factor required for authentication. Make sure that other authentication methods are also in place.


## Example
In this example (taken from [CWE-290: Authentication Bypass by Spoofing](http://cwe.mitre.org/data/definitions/290.html)), the client is authenticated by checking that its IP address is `127.0.0.1`. An attacker might be able to bypass this authentication by spoofing their IP address.


```cpp

#define BUFFER_SIZE (4 * 1024)

void receiveData()
{
  int sock;
  sockaddr_in addr, addr_from;
  char buffer[BUFFER_SIZE];
  int msg_size;
  socklen_t addr_from_len;

  // configure addr
  memset(&addr, 0, sizeof(addr));
  addr.sin_family = AF_INET;
  addr.sin_port = htons(1234);
  addr.sin_addr.s_addr = INADDR_ANY;

  // create and bind the socket
  sock = socket(AF_INET, SOCK_DGRAM, 0);
  bind(sock, (sockaddr *)&addr, sizeof(addr));

  // receive message
  addr_from_len = sizeof(addr_from);
  msg_size = recvfrom(sock, buffer, BUFFER_SIZE, 0, (sockaddr *)&addr_from, &addr_from_len);

  // BAD: the address is controllable by the user, so it
  // could be spoofed to bypass the security check below.
  if ((msg_size > 0) && (strcmp("127.0.0.1", inet_ntoa(addr_from.sin_addr)) == 0))
  {
    // ...
  }
}

```

## References
* Common Weakness Enumeration: [CWE-290](https://cwe.mitre.org/data/definitions/290.html).