# Uncontrolled data used in path expression
Accessing paths controlled by users can allow an attacker to access unexpected resources. This can result in sensitive information being revealed or deleted, or an attacker being able to influence behavior by modifying unexpected files.

Paths that are naively constructed from data controlled by a user may be absolute paths, or may contain unexpected special characters such as "..". Such a path could point anywhere on the file system.


## Recommendation
Validate user input before using it to construct a file path.

Common validation methods include checking that the normalized path is relative and does not contain any ".." components, or checking that the path is contained within a safe folder. The method you should use depends on how the path is used in the application, and whether the path should be a single path component.

If the path should be a single path component (such as a file name), you can check for the existence of any path separators ("/" or "\\"), or ".." sequences in the input, and reject the input if any are found.

Note that removing "../" sequences is *not* sufficient, since the input could still contain a path separator followed by "..". For example, the input ".../...//" would still result in the string "../" if only "../" sequences are removed.

Finally, the simplest (but most restrictive) option is to use an allow list of safe patterns and make sure that the user input matches one of these patterns.


## Example
In this example, a user-provided file name is read from a HTTP request and then used to access a file and send it back to the user. However, a malicious user could enter a file name anywhere on the file system, such as "/etc/passwd" or "../../../etc/passwd".


```csharp
using System;
using System.IO;
using System.Web;

public class TaintedPathHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        String filename = ctx.Request.QueryString["path"];
        // BAD: This could read any file on the filesystem.
        ctx.Response.Write(File.ReadAllText(filename));
    }
}

```
If the input should only be a file name, you can check that it doesn't contain any path separators or ".." sequences.


```csharp
using System;
using System.IO;
using System.Web;

public class TaintedPathHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        String filename = ctx.Request.QueryString["path"];
        // GOOD: ensure that the filename has no path separators or parent directory references
        if (filename.Contains("..") || filename.Contains("/") || filename.Contains("\\"))
        {
            ctx.Response.StatusCode = 400;
            ctx.Response.StatusDescription = "Bad Request";
            ctx.Response.Write("Invalid path");
            return;
        }
        ctx.Response.Write(File.ReadAllText(filename));
    }
}

```
If the input should be within a specific directory, you can check that the resolved path is still contained within that directory.


```csharp
using System;
using System.IO;
using System.Web;

public class TaintedPathHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        String filename = ctx.Request.QueryString["path"];
        
        string publicFolder = Path.GetFullPath("/home/" + user + "/public");
        string filePath = Path.GetFullPath(Path.Combine(publicFolder, filename));

        // GOOD: ensure that the path stays within the public folder
        if (!filePath.StartsWith(publicFolder + Path.DirectorySeparatorChar))
        {
            ctx.Response.StatusCode = 400;
            ctx.Response.StatusDescription = "Bad Request";
            ctx.Response.Write("Invalid path");
            return;
        }
        ctx.Response.Write(File.ReadAllText(filename));
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
