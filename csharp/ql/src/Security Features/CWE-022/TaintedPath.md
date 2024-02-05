# Uncontrolled data used in path expression
Accessing paths controlled by users can allow an attacker to access unexpected resources. This can result in sensitive information being revealed or deleted, or an attacker being able to influence behavior by modifying unexpected files.

Paths that are naively constructed from data controlled by a user may contain unexpected special characters, such as "..". Such a path may potentially point to any directory on the file system.


## Recommendation
Validate user input before using it to construct a file path. Ideally, follow these rules:

* Do not allow more than a single "." character.
* Do not allow directory separators such as "/" or "\\" (depending on the file system).
* Do not rely on simply replacing problematic sequences such as "../". For example, after applying this filter to ".../...//" the resulting string would still be "../".
* Use a whitelist of known good patterns.
* Sanitize potentially tainted paths using `HttpRequest.MapPath`.

## Example
In the first example, a file name is read from a `HttpRequest` and then used to access a file. However, a malicious user could enter a file name which is an absolute path - for example, "/etc/passwd". In the second example, it appears that the user is restricted to opening a file within the "user" home directory. However, a malicious user could enter a filename which contains special characters. For example, the string "../../etc/passwd" will result in the code reading the file located at "/home/\[user\]/../../etc/passwd", which is the system's password file. This file would then be sent back to the user, giving them access to all the system's passwords.


```csharp
using System;
using System.IO;
using System.Web;

public class TaintedPathHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        String path = ctx.Request.QueryString["path"];
        // BAD: This could read any file on the filesystem.
        ctx.Response.Write(File.ReadAllText(path));

        // BAD: This could still read any file on the filesystem.
        ctx.Response.Write(File.ReadAllText("/home/user/" + path));

        // GOOD: MapPath ensures the path is safe to read from.
        string safePath = ctx.Request.MapPath(path, ctx.Request.ApplicationPath, false);
        ctx.Response.Write(File.ReadAllText(safePath));
    }
}

```

## References
* OWASP: [Path Traversal](https://owasp.org/www-community/attacks/Path_Traversal).
* Common Weakness Enumeration: [CWE-22](https://cwe.mitre.org/data/definitions/22.html).
* Common Weakness Enumeration: [CWE-23](https://cwe.mitre.org/data/definitions/23.html).
* Common Weakness Enumeration: [CWE-36](https://cwe.mitre.org/data/definitions/36.html).
* Common Weakness Enumeration: [CWE-73](https://cwe.mitre.org/data/definitions/73.html).
* Common Weakness Enumeration: [CWE-99](https://cwe.mitre.org/data/definitions/99.html).
