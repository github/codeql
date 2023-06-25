/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision medium
 * @id cpp/user-controlled-file-decompression
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources

/**
 * The `gzopen` function, which can perform command substitution.
 */
private class GzopenFunction extends Function {
  GzopenFunction() { hasGlobalName("gzopen") }
}

/**
 * The `gzread` function, which can perform command substitution.
 */
private class GzreadFunction extends Function {
  GzreadFunction() { hasGlobalName("gzread") }
}

module ZlibTaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(FunctionCall fc | fc.getTarget() instanceof GzopenFunction |
      fc.getArgument(0) = source.asExpr()
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall fc | fc.getTarget() instanceof GzreadFunction |
      fc.getArgument(0) = sink.asExpr() and
      not sanitizer(fc)
    )
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(FunctionCall fc | fc.getTarget() instanceof GzopenFunction |
      node1.asExpr() = fc.getArgument(0) and
      node2.asExpr() = fc
    )
  }
}

predicate sanitizer(FunctionCall fc) {
  exists(Expr e | fc.getTarget() instanceof GzreadFunction |
    // a RelationalOperation which isn't compared with a Literal that using for end of read
    TaintTracking::localExprTaint(fc, e.(RelationalOperation).getAChild*()) and
    not e.getAChild*().(Literal).getValue() = ["0", "1", "-1"]
  )
}

module ZlibTaint = TaintTracking::Global<ZlibTaintConfig>;

import ZlibTaint::PathGraph

from ZlibTaint::PathNode source, ZlibTaint::PathNode sink
where ZlibTaint::flowPath(source, sink)
select sink.getNode(), source, sink, "This file extraction depends on a $@.", source.getNode(),
  "potentially untrusted source"
