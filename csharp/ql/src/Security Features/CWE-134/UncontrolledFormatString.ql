/**
 * @name Uncontrolled format string
 * @description Passing untrusted format strings from remote data sources can throw exceptions
 *              and cause a denial of service.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.3
 * @precision high
 * @id cs/uncontrolled-format-string
 * @tags security
 *       external/cwe/cwe-134
 */

import csharp
import semmle.code.csharp.security.dataflow.flowsources.Remote
import semmle.code.csharp.security.dataflow.flowsources.Local
import semmle.code.csharp.frameworks.Format
import FormatString::PathGraph

module FormatStringConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource
    or
    source instanceof LocalFlowSource
  }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(FormatCall call | call.hasInsertions()).getFormatExpr()
  }
}

module FormatString = TaintTracking::Global<FormatStringConfig>;

string getSourceType(DataFlow::Node node) {
  result = node.(RemoteFlowSource).getSourceType()
  or
  result = node.(LocalFlowSource).getSourceType()
}

from FormatString::PathNode source, FormatString::PathNode sink
where FormatString::flowPath(source, sink)
select sink.getNode(), source, sink, "This format string depends on $@.", source.getNode(),
  ("this" + getSourceType(source.getNode()))
