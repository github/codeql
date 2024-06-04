/**
 * @name Unsafe HTML constructed from library input
 * @description Using externally controlled strings to construct HTML might allow a malicious
 *              user to perform a cross-site scripting attack.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.1
 * @precision high
 * @id rb/html-constructed-from-input
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import codeql.ruby.security.UnsafeHtmlConstructionQuery
import UnsafeHtmlConstructionFlow::PathGraph

from
  UnsafeHtmlConstructionFlow::PathNode source, UnsafeHtmlConstructionFlow::PathNode sink,
  Sink sinkNode
where UnsafeHtmlConstructionFlow::flowPath(source, sink) and sink.getNode() = sinkNode
select sinkNode, source, sink,
  "This " + sinkNode.getSinkType() + " which depends on $@ might later allow $@.", source.getNode(),
  "library input", sinkNode.getXssSink(), "cross-site scripting"
