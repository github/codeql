/**
 * @name DOM text reinterpreted as HTML
 * @description Reinterpreting text from the DOM as HTML
 *              can lead to a cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 6.1
 * @precision high
 * @id js/xss-through-dom
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import javascript
import semmle.javascript.security.dataflow.XssThroughDomQuery
import XssThroughDomFlow::PathGraph

from XssThroughDomFlow::PathNode source, XssThroughDomFlow::PathNode sink
where
  XssThroughDomFlow::flowPath(source, sink) and
  not isIgnoredSourceSinkPair(source.getNode(), sink.getNode())
select sink.getNode(), source, sink,
  "$@ is reinterpreted as HTML without escaping meta-characters.", source.getNode(), "DOM text"
