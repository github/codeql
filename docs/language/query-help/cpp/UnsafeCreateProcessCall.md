# NULL application name with an unquoted path in call to CreateProcess

```
ID: cpp/unsafe-create-process-call
Kind: problem
Severity: error
Precision: medium
Tags: security external/cwe/cwe-428 external/microsoft/C6277

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-428/UnsafeCreateProcessCall.ql)

This query indicates that there is a call to a function of the `CreateProcess*` family of functions, which introduces a security vulnerability.


## Recommendation
Do not use `NULL` for the `lpApplicationName` argument to the `CreateProcess*` function.

If you pass `NULL` for `lpApplicationName`, use quotation marks around the executable path in `lpCommandLine`.


## Example
In the following example, `CreateProcessW` is called with a `NULL` value for `lpApplicationName`, and the value for `lpCommandLine` that represent the application path is not quoted and has spaces in it.

If an attacker has access to the file system, they can elevate privileges by creating a file such as `C:\Program.exe` that will be executed instead of the intended application.


```cpp
STARTUPINFOW si;
PROCESS_INFORMATION pi;

// ... 

CreateProcessW(                           // BUG
    NULL,                                 // lpApplicationName
    (LPWSTR)L"C:\\Program Files\\MyApp",  // lpCommandLine
    NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi);

// ...
```
To fix this issue, specify a valid string for `lpApplicationName`, or quote the path for `lpCommandLine`. For example:

`(LPWSTR)L"\"C:\\Program Files\\MyApp\"", // lpCommandLine`


## References
* [CreateProcessA function (Microsoft documentation).](https://docs.microsoft.com/en-us/windows/desktop/api/processthreadsapi/nf-processthreadsapi-createprocessa)
* [CreateProcessW function (Microsoft documentation).](https://docs.microsoft.com/en-us/windows/desktop/api/processthreadsapi/nf-processthreadsapi-createprocessw)
* [CreateProcessAsUserA function (Microsoft documentation).](https://docs.microsoft.com/en-us/windows/desktop/api/processthreadsapi/nf-processthreadsapi-createprocessasusera)
* [CreateProcessAsUserW function (Microsoft documentation).](https://docs.microsoft.com/en-us/windows/desktop/api/processthreadsapi/nf-processthreadsapi-createprocessasuserw)
* [CreateProcessWithLogonW function (Microsoft documentation).](https://docs.microsoft.com/en-us/windows/desktop/api/winbase/nf-winbase-createprocesswithlogonw)
* [CreateProcessWithTokenW function (Microsoft documentation).](https://docs.microsoft.com/en-us/windows/desktop/api/winbase/nf-winbase-createprocesswithtokenw)
* Common Weakness Enumeration: [CWE-428](https://cwe.mitre.org/data/definitions/428.html).