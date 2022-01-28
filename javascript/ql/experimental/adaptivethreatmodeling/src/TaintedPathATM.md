# Uncontrolled data used in path expression (experimental)
Accessing files using paths constructed from user-controlled data can allow an attacker to access unexpected resources. This can result in sensitive information being revealed or deleted, or an attacker being able to influence behavior by modifying unexpected files.

Note: This CodeQL query is an experimental query. Experimental queries generate alerts using machine learning. They might include more false positives but they will improve over time.


## Recommendation
Validate user input before using it to construct a file path, either using an off-the-shelf library like the `sanitize-filename` npm package, or by performing custom validation.

Ideally, follow these rules:

* Do not allow more than a single "." character.
* Do not allow directory separators such as "/" or "\\" (depending on the file system).
* Do not rely on simply replacing problematic sequences such as "../". For example, after applying this filter to ".../...//", the resulting string would still be "../".
* Use a whitelist of known good patterns.

## Example
In the first example, a file name is read from an HTTP request and then used to access a file. However, a malicious user could enter a file name which is an absolute path, such as `"/etc/passwd"`.

In the second example, it appears that the user is restricted to opening a file within the `"user"` home directory. However, a malicious user could enter a file name containing special characters. For example, the string `"../../etc/passwd"` will result in the code reading the file located at `"/home/user/../../etc/passwd"`, which is the system's password file. This file would then be sent back to the user, giving them access to all the system's passwords.


```javascript
var fs = require('fs'),
    http = require('http'),
    url = require('url');

var server = http.createServer(function(req, res) {
  let path = url.parse(req.url, true).query.path;

  // BAD: This could read any file on the file system
  res.write(fs.readFileSync(path));

  // BAD: This could still read any file on the file system
  res.write(fs.readFileSync("/home/user/" + path));
});

```

## References
* OWASP: [Path Traversal](https://owasp.org/www-community/attacks/Path_Traversal).
* npm: [sanitize-filename](https://www.npmjs.com/package/sanitize-filename) package.
