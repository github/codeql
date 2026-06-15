/**
 * @name XSLT query built from user-controlled sources
 * @description Building a XSLT query from user-controlled sources is vulnerable to insertion of
 *              malicious XSLT code by the user.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id py/xslt-injection
 * @tags security
 *       experimental
 *       external/cwe/cwe-643
 */

import python
import XsltInjectionQuery
import XsltInjectionFlow::PathGraph

from XsltInjectionFlow::PathNode source, XsltInjectionFlow::PathNode sink
where XsltInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This XSLT query depends on $@.", source.getNode(),
  "user-provided value"
