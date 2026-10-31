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
import semmle.code.cpp.security.PrintfLike
import semmle.code.cpp.security.FlowSources
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.ir.IR
import Flow::PathGraph

predicate isSource(FlowSource source, string sourceType) { sourceType = source.getSourceType() }

predicate isSink(DataFlow::Node node, FormattingFunction f) {
  exists(Call c, int i |
    c.getTarget() = f and
    i = f.getFormatParameterIndex() and
    c.getArgument(i) = node.asIndirectExpr()
  )
}

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { isSource(node, _) }

  predicate isSink(DataFlow::Node node) { isSink(node, _) }

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
  Function printf, string sourceType, DataFlow::Node source, DataFlow::Node sink,
  Flow::PathNode sourceNode, Flow::PathNode sinkNode
where
  source = sourceNode.getNode() and
  sink = sinkNode.getNode() and
  isSource(source, sourceType) and
  isSink(sink, printf) and
  Flow::flowPath(sourceNode, sinkNode)
select sink, sourceNode, sinkNode,
  "The value of this argument may come from $@ and is being used as a formatting argument to " +
    printf + ".", source, sourceType
