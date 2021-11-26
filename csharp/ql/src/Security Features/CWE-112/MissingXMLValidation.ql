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
import semmle.code.csharp.dataflow.DataFlow::DataFlow::PathGraph

from TaintTrackingConfiguration c, DataFlow::PathNode source, DataFlow::PathNode sink
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "$@ flows to here and is processed as XML without validation because " +
    sink.getNode().(Sink).getReason(), source.getNode(), "User-provided value"
