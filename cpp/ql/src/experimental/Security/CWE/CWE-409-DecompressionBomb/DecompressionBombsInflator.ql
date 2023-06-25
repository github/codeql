/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id cpp/user-controlled-file-decompression2
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources

/**
 * A z_stream Variable as a Flow source
 */
private class ZStreamVar extends VariableAccess {
  ZStreamVar() { this.getType().hasName("z_stream") }
}

/**
 * The `inflate`/`inflateSync` function is used in Flow sink
 */
private class DeflateFunction extends Function {
  DeflateFunction() { hasGlobalName(["inflate", "inflateSync"]) }
}

module ZlibTaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr() instanceof ZStreamVar }

  predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall fc | fc.getTarget() instanceof DeflateFunction |
      fc.getArgument(0) = sink.asExpr()
    )
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(FunctionCall fc | fc.getTarget() instanceof DeflateFunction |
      node1.asExpr() = fc.getArgument(0) and
      node2.asExpr() = fc
    )
  }
}

module ZlibTaint = TaintTracking::Global<ZlibTaintConfig>;

import ZlibTaint::PathGraph

from ZlibTaint::PathNode source, ZlibTaint::PathNode sink
where ZlibTaint::flowPath(source, sink)
select sink.getNode(), source, sink, "This Decompression depends on a $@.", source.getNode(),
  "potentially untrusted source"
