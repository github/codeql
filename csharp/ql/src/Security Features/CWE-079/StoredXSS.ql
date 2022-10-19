/**
 * @name Stored cross-site scripting
 * @description Writing input from the database directly to a web page indicates a cross-site
 *              scripting vulnerability if the data was originally user-provided.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.1
 * @precision medium
 * @id cs/web/stored-xss
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import csharp
import semmle.code.csharp.security.dataflow.flowsources.Stored
import semmle.code.csharp.security.dataflow.XSSQuery
import semmle.code.csharp.security.dataflow.XSSSinks
import semmle.code.csharp.dataflow.DataFlow2
import DataFlow2::PathGraph

class StoredTaintTrackingConfiguration extends TaintTrackingConfiguration {
  override predicate isSource(DataFlow2::Node source) { source instanceof StoredFlowSource }
}

from
  StoredTaintTrackingConfiguration c, DataFlow2::PathNode source, DataFlow2::PathNode sink,
  string explanation
where
  c.hasFlowPath(source, sink) and
  if exists(sink.getNode().(Sink).explanation())
  then explanation = " (" + sink.getNode().(Sink).explanation() + ")"
  else explanation = ""
select sink.getNode(), source, sink,
  "This HTML or JavaScript write" + explanation + " depends on a $@.", source.getNode(),
  "stored (potentially user-provided) value"
