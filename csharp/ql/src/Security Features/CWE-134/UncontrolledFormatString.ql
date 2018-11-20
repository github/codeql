/**
 * @name Uncontrolled format string
 * @description
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id cs/uncontrolled-format-string
 * @tags security
 *       external/cwe/cwe-134
 */

import csharp
import semmle.code.csharp.dataflow.flowsources.Remote
import semmle.code.csharp.dataflow.TaintTracking
import semmle.code.csharp.frameworks.System
import DataFlow::PathGraph

class FormatStringConfiguration extends TaintTracking::Configuration
{
  FormatStringConfiguration() { this = "FormatStringConfiguration" }
  
  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall call | sink.asExpr() = call.getArgumentForName("format") and
      call.getTarget() = any(SystemStringClass s).getFormatMethod()
    )
  }
}

from FormatStringConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "$@ flows to here and is used to format 'String.Format'.", source.getNode(), source.getNode().toString()
