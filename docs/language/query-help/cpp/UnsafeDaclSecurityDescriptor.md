# Setting a DACL to NULL in a SECURITY_DESCRIPTOR

```
ID: cpp/unsafe-dacl-security-descriptor
Kind: problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-732 external/microsoft/C6248

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-732/UnsafeDaclSecurityDescriptor.ql)

This query indicates that a call is setting the DACL field in a `SECURITY_DESCRIPTOR` to null.

When using `SetSecurityDescriptorDacl` to set a discretionary access control (DACL), setting the `bDaclPresent` argument to `TRUE` indicates the prescence of a DACL in the security description in the argument `pDacl`.

When the `pDacl` parameter does not point to a DACL (i.e. it is `NULL`) and the `bDaclPresent` flag is `TRUE`, a `NULL DACL` is specified.

A `NULL DACL` grants full access to any user who requests it; normal security checking is not performed with respect to the object.


## Recommendation
You should not use a `NULL DACL` with an object because any user can change the DACL and owner of the security descriptor.


## Example
In the following example, the call to `SetSecurityDescriptorDacl` is setting an unsafe DACL (`NULL DACL`) to the security descriptor.


```cpp
SECURITY_DESCRIPTOR  pSD;
SECURITY_ATTRIBUTES  SA;

if (!InitializeSecurityDescriptor(&pSD, SECURITY_DESCRIPTOR_REVISION))
{
    // error handling
}
if (!SetSecurityDescriptorDacl(&pSD,
    TRUE,   // bDaclPresent - this value indicates the presence of a DACL in the security descriptor
    NULL,   // pDacl - the pDacl parameter does not point to a DACL. All access will be allowed
    FALSE))
{
    // error handling
}

```
To fix this issue, `pDacl` argument should be a pointer to an `ACL` structure that specifies the DACL for the security descriptor.


## References
* [SetSecurityDescriptorDacl function (Microsoft documentation).](https://docs.microsoft.com/en-us/windows/desktop/api/securitybaseapi/nf-securitybaseapi-setsecuritydescriptordacl)
* Common Weakness Enumeration: [CWE-732](https://cwe.mitre.org/data/definitions/732.html).