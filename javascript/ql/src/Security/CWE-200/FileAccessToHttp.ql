/**
 * @name File data in outbound network request
 * @description Directly sending file data in an outbound network request can indicate unauthorized information disclosure.
 * @kind problem
 * @problem.severity warning
 * @id js/file-access-to-http
 * @tags security
 *       external/cwe/cwe-200
 */

import javascript
import semmle.javascript.security.dataflow.FileAccessToHttp

from FileAccessToHttp::Configuration config, DataFlow::Node src, DataFlow::Node sink
where config.hasFlow (src, sink)
select sink, "$@ flows directly to outbound network request", src, "File data"
