# Uncontrolled data used in path expression

```
ID: py/path-injection
Kind: path-problem
Severity: error
Precision: high
Tags: correctness security external/owasp/owasp-a1 external/cwe/cwe-022 external/cwe/cwe-023 external/cwe/cwe-036 external/cwe/cwe-073 external/cwe/cwe-099

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/python/ql/src/Security/CWE-022/PathInjection.ql)

Accessing files using paths constructed from user-controlled data can allow an attacker to access unexpected resources. This can result in sensitive information being revealed or deleted, or an attacker being able to influence behavior by modifying unexpected files.


## Recommendation
Validate user input before using it to construct a file path, either using an off-the-shelf library function like `werkzeug.utils.secure_filename`, or by performing custom validation.

Ideally, follow these rules:

* Do not allow more than a single "." character.
* Do not allow directory separators such as "/" or "\" (depending on the file system).
* Do not rely on simply replacing problematic sequences such as "../". For example, after applying this filter to ".../...//", the resulting string would still be "../".
* Use an allowlist of known good patterns.

## Example
In the first example, a file name is read from an HTTP request and then used to access a file. However, a malicious user could enter a file name that is an absolute path, such as `"/etc/passwd"`.

In the second example, it appears that the user is restricted to opening a file within the `"user"` home directory. However, a malicious user could enter a file name containing special characters. For example, the string `"../../../etc/passwd"` will result in the code reading the file located at `"/server/static/images/../../../etc/passwd"`, which is the system's password file. This file would then be sent back to the user, giving them access to all the system's passwords.

In the third example, the path used to access the file system is normalized *before* being checked against a known prefix. This ensures that regardless of the user input, the resulting path is safe.


```python
import os.path


urlpatterns = [
    # Route to user_picture
    url(r'^user-pic1$', user_picture1, name='user-picture1'),
    url(r'^user-pic2$', user_picture2, name='user-picture2'),
    url(r'^user-pic3$', user_picture3, name='user-picture3')
]


def user_picture1(request):
    """A view that is vulnerable to malicious file access."""
    filename = request.GET.get('p')
    # BAD: This could read any file on the file system
    data = open(filename, 'rb').read()
    return HttpResponse(data)

def user_picture2(request):
    """A view that is vulnerable to malicious file access."""
    base_path = '/server/static/images'
    filename = request.GET.get('p')
    # BAD: This could still read any file on the file system
    data = open(os.path.join(base_path, filename), 'rb').read()
    return HttpResponse(data)

def user_picture3(request):
    """A view that is not vulnerable to malicious file access."""
    base_path = '/server/static/images'
    filename = request.GET.get('p')
    #GOOD -- Verify with normalised version of path
    fullpath = os.path.normpath(os.path.join(base_path, filename))
    if not fullpath.startswith(base_path):
        raise SecurityException()
    data = open(fullpath, 'rb').read()
    return HttpResponse(data)

```

## References
* OWASP: [Path Traversal](https://www.owasp.org/index.php/Path_traversal).
* npm: [werkzeug.utils.secure_filename](http://werkzeug.pocoo.org/docs/utils/#werkzeug.utils.secure_filename).
* Common Weakness Enumeration: [CWE-22](https://cwe.mitre.org/data/definitions/22.html).
* Common Weakness Enumeration: [CWE-23](https://cwe.mitre.org/data/definitions/23.html).
* Common Weakness Enumeration: [CWE-36](https://cwe.mitre.org/data/definitions/36.html).
* Common Weakness Enumeration: [CWE-73](https://cwe.mitre.org/data/definitions/73.html).
* Common Weakness Enumeration: [CWE-99](https://cwe.mitre.org/data/definitions/99.html).