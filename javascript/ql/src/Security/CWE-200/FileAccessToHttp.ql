/**
 * @name File Access data flows to Http POST/PUT 
 * @description Writing data from file directly to http body or request header can be an indication to data exfiltration or unauthorized information disclosure.
 * @kind problem
 * @problem.severity warning
 * @id js/file-access-to-http
 * @tags security
 *       external/cwe/cwe-200
 */

import javascript
import semmle.javascript.security.dataflow.FileAccessToHttp

from FileAccessToHttpDataFlow::Configuration config, DataFlow::Node src, DataFlow::Node sink
where config.hasFlow (src, sink)
select src, "$@ flows directly to Http request body", sink, "File access"
