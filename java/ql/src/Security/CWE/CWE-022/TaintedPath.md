# Uncontrolled data used in path expression
Accessing paths controlled by users can allow an attacker to access unexpected resources. This can result in sensitive information being revealed or deleted, or an attacker being able to influence behavior by modifying unexpected files.

Paths that are naively constructed from data controlled by a user may be absolute paths or contain unexpected special characters, such as "..". Such a path may potentially point anywhere on the file system.


## Recommendation
Validate user input before using it to construct a file path.

Common validation methods include checking that the normalized path is relative and does not contain any ".." components, or that the path is contained within a safe folder. The validation method to use depends on how the path is used in the application and whether the path is supposed to be a single path component.

If the path is supposed to be a single path component (such as a file name) you can check for the existence of any path separators ("/" or "\\") or ".." sequences in the input, and reject the input if any are found.

Note that removing "../" sequences is *not* sufficient, since the input could still contain a path separator followed by "..". For example, the input ".../...//" would still result in the string "../" if only "../" sequences are removed.

Finally, the simplest (but most restrictive) option is to use an allow list of safe patterns and make sure that the user input matches one of these patterns.


## Example
In this example, a file name is read from a `java.net.Socket` and then used to access a file and send it back over the socket. However, a malicious user could enter a file name anywhere on the file system, such as "/etc/passwd" or "../../../etc/passwd".


```java
public void sendUserFile(Socket sock, String user) {
	BufferedReader filenameReader = new BufferedReader(
			new InputStreamReader(sock.getInputStream(), "UTF-8"));
	String filename = filenameReader.readLine();
	// BAD: read from a file without checking its path
	BufferedReader fileReader = new BufferedReader(new FileReader(filename));
	String fileLine = fileReader.readLine();
	while(fileLine != null) {
		sock.getOutputStream().write(fileLine.getBytes());
		fileLine = fileReader.readLine();
	}
}

```
If the input is just supposed to be a file name, you can check that it doesn't contain any path separators or ".." sequences.


```java
public void sendUserFileGood(Socket sock, String user) {
	BufferedReader filenameReader = new BufferedReader(
			new InputStreamReader(sock.getInputStream(), "UTF-8"));
	String filename = filenameReader.readLine();
	// GOOD: ensure that the filename has no path separators or parent directory references
	if (filename.contains("..") || filename.contains("/") || filename.contains("\\")) {
		throw new IllegalArgumentException("Invalid filename");
	}
	BufferedReader fileReader = new BufferedReader(new FileReader(filename));
	String fileLine = fileReader.readLine();
	while(fileLine != null) {
		sock.getOutputStream().write(fileLine.getBytes());
		fileLine = fileReader.readLine();
	}	
}

```
If the input is supposed to be found within a specific directory, you can check that the resolved path is still contained within that directory.


```java
public void sendUserFileGood(Socket sock, String user) {
	BufferedReader filenameReader = new BufferedReader(
			new InputStreamReader(sock.getInputStream(), "UTF-8"));
	String filename = filenameReader.readLine();

	Path publicFolder = Paths.get("/home/" + user + "/public").normalize().toAbsolutePath();
	Path filePath = publicFolder.resolve(filename).normalize().toAbsolutePath();

	// GOOD: ensure that the path stays within the public folder
	if (!filePath.startsWith(publicFolder)) {
		throw new IllegalArgumentException("Invalid filename");
	}
	BufferedReader fileReader = new BufferedReader(new FileReader(filePath.toString()));
	String fileLine = fileReader.readLine();
	while(fileLine != null) {
		sock.getOutputStream().write(fileLine.getBytes());
		fileLine = fileReader.readLine();
	}
}
```

## References
* OWASP: [Path Traversal](https://owasp.org/www-community/attacks/Path_Traversal).
* Common Weakness Enumeration: [CWE-22](https://cwe.mitre.org/data/definitions/22.html).
* Common Weakness Enumeration: [CWE-23](https://cwe.mitre.org/data/definitions/23.html).
* Common Weakness Enumeration: [CWE-36](https://cwe.mitre.org/data/definitions/36.html).
* Common Weakness Enumeration: [CWE-73](https://cwe.mitre.org/data/definitions/73.html).
