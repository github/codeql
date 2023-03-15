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

private module ExternallyControlledFormatStringLocalConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(StringFormat formatCall).getFormatArgument()
  }
}

module ExternallyControlledFormatStringLocalFlow =
  TaintTracking::Make<ExternallyControlledFormatStringLocalConfig>;

import ExternallyControlledFormatStringLocalFlow::PathGraph

from
  ExternallyControlledFormatStringLocalFlow::PathNode source,
  ExternallyControlledFormatStringLocalFlow::PathNode sink, StringFormat formatCall
where
  ExternallyControlledFormatStringLocalFlow::hasFlowPath(source, sink) and
  sink.getNode().asExpr() = formatCall.getFormatArgument()
select formatCall.getFormatArgument(), source, sink, "Format string depends on a $@.",
  source.getNode(), "user-provided value"
