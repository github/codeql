/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id cpp/user-controlled-file-decompression3
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources

/**
 * A Bytef Variable as a Flow source
 */
private class BytefVar extends VariableAccess {
  BytefVar() { this.getType().hasName("Bytef") }
}

/**
 * The `uncompress`/`uncompress2` function is used in Flow sink
 */
private class UncompressFunction extends Function {
  UncompressFunction() { hasGlobalName(["uncompress", "uncompress2"]) }
}

module ZlibTaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr() instanceof BytefVar }

  predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall fc | fc.getTarget() instanceof UncompressFunction |
      fc.getArgument(0) = sink.asExpr()
    )
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(FunctionCall fc | fc.getTarget() instanceof UncompressFunction |
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
