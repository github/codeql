/**
 * @name Unsafe code constructed from library input
 * @description Using externally controlled strings to construct code may allow a malicious
 *              user to execute arbitrary code.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 6.1
 * @precision medium
 * @id rb/unsafe-code-construction
 * @tags security
 *       external/cwe/cwe-094
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import codeql.ruby.security.UnsafeCodeConstructionQuery
import UnsafeCodeConstructionFlow::PathGraph

from
  UnsafeCodeConstructionFlow::PathNode source, UnsafeCodeConstructionFlow::PathNode sink,
  Sink sinkNode
where UnsafeCodeConstructionFlow::flowPath(source, sink) and sinkNode = sink.getNode()
select sink.getNode(), source, sink,
  "This " + sinkNode.getSinkType() + " which depends on $@ is later $@.", source.getNode(),
  "library input", sinkNode.getCodeSink(), "interpreted as code"
