/**
 * @name XML internal entity expansion
 * @description Parsing user input as an XML document with arbitrary internal
 *              entity expansion is vulnerable to denial-of-service attacks.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id js/xml-bomb
 * @tags security
 *       external/cwe/cwe-776
 *       external/cwe/cwe-400
 */

import javascript
import semmle.javascript.security.dataflow.XmlBomb::XmlBomb

from Configuration c, DataFlow::Node source, DataFlow::Node sink
where c.hasFlow(source, sink)
select sink, "A $@ is parsed as XML without guarding against uncontrolled entity expansion.",
       source, "user-provided value"
