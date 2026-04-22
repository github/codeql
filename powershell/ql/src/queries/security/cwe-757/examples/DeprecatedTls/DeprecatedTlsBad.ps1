# BAD: Using deprecated SSL 3.0
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Ssl3

# BAD: Using deprecated TLS 1.0
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls

# BAD: Using deprecated TLS 1.1
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls11
