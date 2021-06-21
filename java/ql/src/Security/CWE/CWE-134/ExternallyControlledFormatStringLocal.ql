/**
 * @name Use of externally-controlled format string from local source
 * @description Using external input in format strings can lead to exceptions or information leaks.
 * @kind path-problem
 * @problem.severity recommendation
 * @security-severity 9.3
 * @precision medium
 * @id java/tainted-format-string-local
 * @tags security
 *       external/cwe/cwe-134
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.StringFormat
import DataFlow::PathGraph

class ExternallyControlledFormatStringLocalConfig extends TaintTracking::Configuration {
  ExternallyControlledFormatStringLocalConfig() {
    this = "ExternallyControlledFormatStringLocalConfig"
  }

  override predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(StringFormat formatCall).getFormatArgument()
  }
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, StringFormat formatCall,
  ExternallyControlledFormatStringLocalConfig conf
where conf.hasFlowPath(source, sink) and sink.getNode().asExpr() = formatCall.getFormatArgument()
select formatCall.getFormatArgument(), source, sink,
  "$@ flows to here and is used in a format string.", source.getNode(), "User-provided value"
