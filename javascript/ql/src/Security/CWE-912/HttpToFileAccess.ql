/**
 * @name User-controlled data written to file
 * @description Writing user-controlled data directly to the file system allows arbitrary file upload and might indicate a backdoor.
 * @kind problem
 * @problem.severity warning
 * @id js/http-to-file-access
 * @tags security
 *       external/cwe/cwe-912
 */

import javascript
import semmle.javascript.security.dataflow.HttpToFileAccess

from HttpToFileAccess::Configuration configuration, DataFlow::Node src, DataFlow::Node sink
where configuration.hasFlow(src, sink)
select sink, "$@ flows to file system", src, "Untrusted data"
