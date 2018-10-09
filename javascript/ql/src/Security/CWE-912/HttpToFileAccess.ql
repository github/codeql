/**
 * @name Http response data flows to File Access 
 * @description Writing data from an HTTP request directly to the file system allows arbitrary file upload and might indicate a backdoor.
 * @kind problem
 * @problem.severity warning
 * @id js/http-to-file-access
 * @tags security
 *       external/cwe/cwe-912
 */

import javascript
import semmle.javascript.security.dataflow.HttpToFileAccess

from HttpToFileAccessFlow::Configuration configuration, DataFlow::Node src, DataFlow::Node sink
where configuration.hasFlow(src, sink)
select sink, "$@ flows to file system", src, "Untrusted data received from Http response"
