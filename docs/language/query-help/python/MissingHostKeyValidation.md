# Accepting unknown SSH host keys when using Paramiko

```
ID: py/paramiko-missing-host-key-validation
Kind: problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-295

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/python/ql/src/Security/CWE-295/MissingHostKeyValidation.ql)

In the Secure Shell (SSH) protocol, host keys are used to verify the identity of remote hosts. Accepting unknown host keys may leave the connection open to man-in-the-middle attacks.


## Recommendation
Do not accept unknown host keys. In particular, do not set the default missing host key policy for the Paramiko library to either `AutoAddPolicy` or `WarningPolicy`. Both of these policies continue even when the host key is unknown. The default setting of `RejectPolicy` is secure because it throws an exception when it encounters an unknown host key.


## Example
The following example shows two ways of opening an SSH connection to `example.com`. The first function sets the missing host key policy to `AutoAddPolicy`. If the host key verification fails, the client will continue to interact with the server, even though the connection may be compromised. The second function sets the host key policy to `RejectPolicy`, and will throw an exception if the host key verification fails.


```python
from paramiko.client import SSHClient, AutoAddPolicy, RejectPolicy

def unsafe_connect():
    client = SSHClient()
    client.set_missing_host_key_policy(AutoAddPolicy)
    client.connect("example.com")

    # ... interaction with server

    client.close()

def safe_connect():
    client = SSHClient()
    client.set_missing_host_key_policy(RejectPolicy)
    client.connect("example.com")

    # ... interaction with server

    client.close()

```

## References
* Paramiko documentation: [set_missing_host_key_policy](http://docs.paramiko.org/en/2.4/api/client.html?highlight=set_missing_host_key_policy#paramiko.client.SSHClient.set_missing_host_key_policy).
* Common Weakness Enumeration: [CWE-295](https://cwe.mitre.org/data/definitions/295.html).