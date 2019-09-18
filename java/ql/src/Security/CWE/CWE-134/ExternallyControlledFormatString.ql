/**
 * @name Use of externally-controlled format string
 * @description Using external input in format strings can lead to exceptions or information leaks.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/tainted-format-string
 * @tags security
 *       external/cwe/cwe-134
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.StringFormat
import DataFlow::PathGraph

class ExternallyControlledFormatStringConfig extends TaintTracking::Configuration {
  ExternallyControlledFormatStringConfig() { this = "ExternallyControlledFormatStringConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(StringFormat formatCall).getFormatArgument()
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof NumericType or node.getType() instanceof BooleanType
  }
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, StringFormat formatCall,
  ExternallyControlledFormatStringConfig conf
where conf.hasFlowPath(source, sink) and sink.getNode().asExpr() = formatCall.getFormatArgument()
select formatCall.getFormatArgument(), source, sink,
  "$@ flows to here and is used in a format string.", source.getNode(), "User-provided value"
