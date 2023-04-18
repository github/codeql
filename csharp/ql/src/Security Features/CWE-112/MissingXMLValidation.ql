/**
 * @name Missing XML validation
 * @description User input should not be processed as XML without validating it against a known
 *              schema.
 * @kind path-problem
 * @problem.severity recommendation
 * @security-severity 4.3
 * @precision high
 * @id cs/xml/missing-validation
 * @tags security
 *       external/cwe/cwe-112
 */

import csharp
import semmle.code.csharp.security.dataflow.MissingXMLValidationQuery
import MissingXmlValidation::PathGraph

from MissingXmlValidation::PathNode source, MissingXmlValidation::PathNode sink
where MissingXmlValidation::flowPath(source, sink)
select sink.getNode(), source, sink,
  "This XML processing depends on a $@ without validation because " +
    sink.getNode().(Sink).getReason(), source.getNode(), "user-provided value"
