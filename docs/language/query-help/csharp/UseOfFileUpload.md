# Use of file upload

```
ID: cs/web/file-upload
Kind: problem
Severity: recommendation
Precision: high
Tags: security maintainability frameworks/asp.net external/cwe/cwe-434

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/csharp/ql/src/Input%20Validation/UseOfFileUpload.ql)

Allowing end users to upload files may lead to severe security threats. Attackers may use this open door to compromise your application, either by overwriting data or by injecting malicious code to run on your server.


## Recommendation
Whist it might not be possible to remove the ability to upload files, special care should be taken to ensure files are handled in a secure manner. The following checks should be implemented to ensure the security of your application:

* Validate each path where the uploaded data is written to.
* Check the content of the data being uploaded without just relying on the MIME type.
* Set a size limit for the uploaded data.
* Do not run your web application with administrator privileges.
* Log each upload request.
* Do not display system information or exception in case the upload fails as this information may help attackers to find a breach.

## References
* Common Weakness Enumeration: [CWE-434](https://cwe.mitre.org/data/definitions/434.html).