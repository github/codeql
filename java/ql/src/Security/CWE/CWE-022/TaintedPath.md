# Uncontrolled data used in path expression
Accessing paths controlled by users can allow an attacker to access unexpected resources. This can result in sensitive information being revealed or deleted, or an attacker being able to influence behavior by modifying unexpected files.

Paths that are naively constructed from data controlled by a user may contain unexpected special characters, such as "..". Such a path may potentially point anywhere on the file system.


## Recommendation
Validate user input before using it to construct a file path.

The choice of validation depends on whether you want to allow the user to specify complex paths with multiple components that may span multiple folders, or only simple filenames without a path component.

In the former case, a common strategy is to make sure that the constructed file path is contained within a safe root folder, for example by checking that the path starts with the root folder. Additionally, you need to ensure that the path does not contain any ".." components, since otherwise even a path that starts with the root folder could be used to access files outside the root folder.

In the latter case, if you want to ensure that the user input is interpreted as a simple filename without a path component, you can remove all path separators ("/" or "\\") and all ".." sequences from the input before using it to construct a file path. Note that it is *not* sufficient to only remove "../" sequences: for example, applying this filter to ".../...//" would still result in the string "../".

Finally, the simplest (but most restrictive) option is to use an allow list of safe patterns and make sure that the user input matches one of these patterns.


## Example
In this example, a file name is read from a `java.net.Socket` and then used to access a file and send it back over the socket. However, a malicious user could enter a file name anywhere on the file system, such as "/etc/passwd".


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
Simply checking that the path is under a trusted location (such as a known public folder) is not enough, however, since the path could contain relative components such as "..". To fix this, check that it does not contain ".." and starts with the public folder.


```java
public void sendUserFileGood(Socket sock, String user) {
	BufferedReader filenameReader = new BufferedReader(
			new InputStreamReader(sock.getInputStream(), "UTF-8"));
	String filename = filenameReader.readLine();
	// GOOD: ensure that the file is in a designated folder in the user's home directory
	if (!filename.contains("..") && filename.startsWith("/home/" + user + "/public/")) {
		BufferedReader fileReader = new BufferedReader(new FileReader(filename));
		String fileLine = fileReader.readLine();
		while(fileLine != null) {
			sock.getOutputStream().write(fileLine.getBytes());
			fileLine = fileReader.readLine();
		}
	}	
}

```

## References
* OWASP: [Path Traversal](https://owasp.org/www-community/attacks/Path_Traversal).
* Common Weakness Enumeration: [CWE-22](https://cwe.mitre.org/data/definitions/22.html).
* Common Weakness Enumeration: [CWE-23](https://cwe.mitre.org/data/definitions/23.html).
* Common Weakness Enumeration: [CWE-36](https://cwe.mitre.org/data/definitions/36.html).
* Common Weakness Enumeration: [CWE-73](https://cwe.mitre.org/data/definitions/73.html).
