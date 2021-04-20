/**
 * @name IP address spoofing
 * @description A remote endpoint identifier is read from an HTTP header. Attackers can modify the value
 *              of the identifier to forge the client ip.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/ip-address-spoofing
 * @tags security
 *       external/cwe/cwe-348
 */

import java
import UseOfLessTrustedSourceLib
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

/**
 * Taint-tracking configuration tracing flow from obtain client ip to use the client ip.
 */
class UseOfLessTrustedSourceConfig extends TaintTracking::Configuration {
  UseOfLessTrustedSourceConfig() { this = "UseOfLessTrustedSourceConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof UseOfLessTrustedSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UseOfLessTrustedSink }

  /**
   * Splitting a header value by `,` and taking an entry other than the first is sanitizing, because
   * later entries may originate from more-trustworthy intermediate proxies, not the original client.
   */
  override predicate isSanitizer(DataFlow::Node node) {
    exists(ArrayAccess aa, MethodAccess ma | aa.getArray() = ma |
      ma.getQualifier() = node.asExpr() and
      ma.getMethod() instanceof SplitMethod and
      not aa.getIndexExpr().(CompileTimeConstantExpr).getIntValue() = 0
    )
  }

  override predicate isAdditionalTaintStep(DataFlow::Node prod, DataFlow::Node succ) {
    exists(MethodAccess ma |
      ma.getAnArgument() = prod.asExpr() and
      ma = succ.asExpr() and
      ma.getMethod().getReturnType() instanceof BooleanType
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, UseOfLessTrustedSourceConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "IP address spoofing might include code from $@.",
  source.getNode(), "this user input"
