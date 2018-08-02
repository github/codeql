/**
 * @name Missing XML validation
 * @description User input should not be processed as XML without validating it against a known
 *              schema.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/xml/missing-validation
 * @tags security
 *       external/cwe/cwe-112
 */
import csharp
import semmle.code.csharp.security.dataflow.MissingXMLValidation::MissingXMLValidation

from TaintTrackingConfiguration c, Source source, Sink sink
where c.hasFlow(source, sink)
select sink, "$@ flows to here and is processed as XML without validation because " + sink.getReason(), source, "User-provided value"
