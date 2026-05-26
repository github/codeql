/**
 * @name Uncontrolled format string
 * @description Using externally-controlled format strings in
 *              printf-style functions can lead to buffer overflows
 *              or data representation problems.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 9.3
 * @precision high
 * @id cpp/tainted-format-string
 * @tags reliability
 *       security
 *       external/cwe/cwe-134
 */

import cpp
import semmle.code.cpp.security.Security
import semmle.code.cpp.security.FunctionWithWrappers
import semmle.code.cpp.security.FlowSources
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.ir.IR
import Flow::PathGraph

predicate isSource(FlowSource source, string sourceType) { sourceType = source.getSourceType() }

/**
 * Holds if `f` is a printf-like function or a (possibly nested) wrapper
 * that forwards a format-string parameter to one.
 *
 * Functions that *implement* printf-like behavior (e.g. a custom
 * `vsnprintf` variant) internally parse the caller-supplied format string
 * and build small, bounded, local format strings such as `"%d"` or `"%ld"`
 * for inner `sprintf` calls.  Taint that reaches those inner calls via the
 * parsed format specifier is not exploitable, so sinks inside such
 * functions should be excluded.
 */
private predicate isPrintfImplementation(Function f) {
  f instanceof PrintfLikeFunction
  or
  exists(PrintfLikeFunction printf | printf.wrapperFunction(f, _, _))
}

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { isSource(node, _) }

  predicate isSink(DataFlow::Node node) {
    exists(PrintfLikeFunction printf |
      printf.outermostWrapperFunctionCall([node.asExpr(), node.asIndirectExpr()], _)
    ) and
    not isPrintfImplementation([node.asExpr(), node.asIndirectExpr()].getEnclosingFunction())
  }

  private predicate isArithmeticNonCharType(ArithmeticType type) {
    not type instanceof CharType and
    not type instanceof Char8Type and
    not type instanceof Char16Type and
    not type instanceof Char32Type
  }

  predicate isBarrier(DataFlow::Node node) {
    isSink(node) and isArithmeticNonCharType(node.asExpr().getUnspecifiedType())
    or
    isArithmeticNonCharType(node.asCertainDefinition().getUnspecifiedType())
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module Flow = TaintTracking::Global<Config>;

from
  PrintfLikeFunction printf, string printfFunction, string sourceType, DataFlow::Node source,
  DataFlow::Node sink, Flow::PathNode sourceNode, Flow::PathNode sinkNode
where
  source = sourceNode.getNode() and
  sink = sinkNode.getNode() and
  isSource(source, sourceType) and
  printf.outermostWrapperFunctionCall([sink.asExpr(), sink.asIndirectExpr()], printfFunction) and
  Flow::flowPath(sourceNode, sinkNode)
select sink, sourceNode, sinkNode,
  "The value of this argument may come from $@ and is being used as a formatting argument to " +
    printfFunction + ".", source, sourceType
