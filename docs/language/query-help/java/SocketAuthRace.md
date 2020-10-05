# Race condition in socket authentication

```
ID: java/socket-auth-race-condition
Kind: problem
Severity: warning
Precision: medium
Tags: security external/cwe/cwe-421

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/java/ql/src/Security/CWE/CWE-421/SocketAuthRace.ql)

A common pattern is to have a channel of communication open with a user, and then to open another channel, for example to transfer data. However, if user authentication is done over the original channel rather than the alternate channel, then an attacker may be able to connect to the alternate channel before the legitimate user does. This allows the attacker to impersonate the user by "piggybacking" on any previous authentication.


## Recommendation
When opening an alternate channel for an authenticated user (for example, a Java `Socket`), always authenticate the user over the new channel.


## Example
This example shows two ways of opening a connection for a user. In the first example, authentication is determined based on materials that the user has already provided (for example, their username and/or password), and then a new channel is opened. However, no authentication is done over the new channel, and so an attacker could connect to it before the user connects.

In the second example, authentication is done over the socket channel itself, which verifies that the newly connected user is in fact the user that was expected.


```java
public void doConnect(int desiredPort, String username) {
	ServerSocket listenSocket = new ServerSocket(desiredPort);

	if (isAuthenticated(username)) {
		Socket connection1 = listenSocket.accept();
		// BAD: no authentication over the socket connection
		connection1.getOutputStream().write(secretData);
	}
}

public void doConnect(int desiredPort, String username) {
	ServerSocket listenSocket = new ServerSocket(desiredPort);

	Socket connection2 = listenSocket.accept();
	// GOOD: authentication happens over the socket
	if (doAuthenticate(connection2, username)) {
		connection2.getOutputStream().write(secretData);
	}
}
```

## References
* Common Weakness Enumeration: [CWE-421](https://cwe.mitre.org/data/definitions/421.html).