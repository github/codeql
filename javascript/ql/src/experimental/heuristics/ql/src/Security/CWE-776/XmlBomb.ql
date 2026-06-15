/**
 * @name XML internal entity expansion with additional heuristic sources
 * @description Parsing user input as an XML document with arbitrary internal
 *              entity expansion is vulnerable to denial-of-service attacks.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id js/xml-bomb-more-sources
 * @tags experimental
 *       security
 *       external/cwe/cwe-776
 *       external/cwe/cwe-400
 */

import javascript
import semmle.javascript.security.dataflow.XmlBombQuery
import XmlBombFlow::PathGraph
import semmle.javascript.heuristics.AdditionalSources

from XmlBombFlow::PathNode source, XmlBombFlow::PathNode sink
where XmlBombFlow::flowPath(source, sink) and source.getNode() instanceof HeuristicSource
select sink.getNode(), source, sink,
  "XML parsing depends on a $@ without guarding against uncontrolled entity expansion.",
  source.getNode(), "user-provided value"
