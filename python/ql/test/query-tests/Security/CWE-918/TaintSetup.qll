import python
// Should match what is in Security/CWE-918/SSRF.ql
import semmle.python.web.HttpRequest // incoming server request
import semmle.python.web.ClientHttpRequest // outgoing client request
