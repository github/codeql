/**
 * @name XML internal entity expansion
 * @description Parsing user input as an XML document with arbitrary internal
 *              entity expansion is vulnerable to denial-of-service attacks.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id js/xml-bomb
 * @tags security
 *       external/cwe/cwe-776
 *       external/cwe/cwe-400
 */

import javascript
import semmle.javascript.security.dataflow.XmlBomb::XmlBomb
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "A $@ is parsed as XML without guarding against uncontrolled entity expansion.", source.getNode(),
  "user-provided value"
