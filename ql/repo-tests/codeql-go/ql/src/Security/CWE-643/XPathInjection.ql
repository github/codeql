/**
 * @name XPath injection
 * @description Building an XPath expression from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id go/xml/xpath-injection
 * @tags security
 *       external/cwe/cwe-643
 */

import go
import semmle.go.security.XPathInjection::XPathInjection
import DataFlow::PathGraph

/** Holds if `node` is either a string or a byte slice */
predicate isStringOrByte(DataFlow::PathNode node) {
  exists(Type t | t = node.getNode().getType().getUnderlyingType() |
    t instanceof StringType or t instanceof ByteSliceType
  )
}

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink) and isStringOrByte(sink)
select sink.getNode(), source, sink, "$@ flows here and is used in an XPath expression.",
  source.getNode(), "A user-provided value"
