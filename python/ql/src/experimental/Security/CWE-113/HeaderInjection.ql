/**
 * @name HTTP Header Injection
 * @description User input should not be used in HTTP headers, otherwise a malicious user
 *              may be able to inject a value that could manipulate the response.
 * @kind path-problem
 * @problem.severity error
 * @id py/header-injection
 * @tags security
 *       experimental
 *       external/cwe/cwe-113
 *       external/cwe/cwe-079
 */

// determine precision above
import python
import experimental.semmle.python.security.injection.HTTPHeaders
import HeaderInjectionFlow::PathGraph

from HeaderInjectionFlow::PathNode source, HeaderInjectionFlow::PathNode sink
where HeaderInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This HTTP header is constructed from a $@.", source.getNode(),
  "user-provided value"
