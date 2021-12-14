/**
 * @name HTTP Header Injection
 * @description User input should not be used in HTTP headers, otherwise a malicious user
 *              may be able to inject a value that could manipulate the response.
 * @kind path-problem
 * @problem.severity error
 * @id py/header-injection
 * @tags security
 *       external/cwe/cwe-113
 *       external/cwe/cwe-079
 */

// determine precision above
import python
import experimental.semmle.python.security.injection.HTTPHeaders
import DataFlow::PathGraph

from HeaderInjectionFlowConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ HTTP header is constructed from a $@.", sink.getNode(),
  "This", source.getNode(), "user-provided value"
