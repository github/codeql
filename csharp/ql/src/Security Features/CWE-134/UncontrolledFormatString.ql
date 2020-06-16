/**
 * @name Uncontrolled format string
 * @description Passing untrusted format strings from remote data sources can throw exceptions
 *              and cause a denial of service.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id cs/uncontrolled-format-string
 * @tags security
 *       external/cwe/cwe-134
 */

import csharp
import semmle.code.csharp.security.dataflow.flowsources.Remote
import semmle.code.csharp.security.dataflow.flowsources.Local
import semmle.code.csharp.dataflow.TaintTracking
import semmle.code.csharp.frameworks.Format
import DataFlow::PathGraph

class FormatStringConfiguration extends TaintTracking::Configuration {
  FormatStringConfiguration() { this = "FormatStringConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource
    or
    source instanceof LocalFlowSource
  }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(FormatCall call).getFormatExpr()
  }
}

from FormatStringConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows to here and is used as a format string.",
  source.getNode(), source.getNode().toString()
