/**
 * @name Stored cross-site scripting
 * @description Writing input from the database directly to a web page indicates a cross-site
 *              scripting vulnerability if the data was originally user-provided.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id cs/web/stored-xss
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */
import csharp
import semmle.code.csharp.security.dataflow.flowsources.Stored
import semmle.code.csharp.security.dataflow.XSS::XSS

class StoredTaintTrackingConfiguration extends TaintTrackingConfiguration {
  override predicate isSource(DataFlow::Node source) {
    source instanceof StoredFlowSource
  }
}

from StoredTaintTrackingConfiguration c, StoredFlowSource source, Sink sink, string explanation
where c.hasFlow(source, sink)
and
  if exists(sink.explanation())
  then explanation = ": " + sink.explanation() + "."
  else explanation = "."
select sink, "$@ flows to here and is written to HTML or javascript" + explanation, source, "Stored user-provided value"
