/**
 * @name Uncontrolled format string
 * @description Using external input in format strings can lead to exceptions or information leaks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.3
 * @precision high
 * @id swift/uncontrolled-format-string
 * @tags security
 *       external/cwe/cwe-134
 */

import swift
import codeql.swift.StringFormat
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.FlowSources
import codeql.swift.dataflow.ExternalFlow
import codeql.swift.frameworks.StandardLibrary.PointerTypes
import codeql.swift.security.PredicateInjectionExtensions

// Copied from swift/ql/lib/codeql/swift/security/UncontrolledFormatStringExtensions.qll.

/**
 * A dataflow sink for uncontrolled format string vulnerabilities.
 */
abstract class UncontrolledFormatStringSink extends DataFlow::Node { }

/**
 * A barrier for uncontrolled format string vulnerabilities.
 */
abstract class UncontrolledFormatStringBarrier extends DataFlow::Node { }

/**
 * A unit class for adding additional flow steps.
 */
class UncontrolledFormatStringAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step for paths related to uncontrolled format string vulnerabilities.
   */
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

/**
 * A default uncontrolled format string sink.
 */
private class DefaultUncontrolledFormatStringSink extends UncontrolledFormatStringSink {
  DefaultUncontrolledFormatStringSink() {
    // the format argument to a `FormattingFunctionCall`.
    this.asExpr() = any(FormattingFunctionCall fc).getFormat()
    or
    // a sink defined in a CSV model.
    sinkNode(this, "format-string")
  }
}

/**
 * Holds if `f`, `ix` describe `pd` and `pd` is a parameter that might be a format
 * string.
 */
pragma[noinline]
predicate formatLikeHeuristic(Callable f, int ix, ParamDecl pd) {
  pd.getName() = ["format", "formatString", "fmt"] and
  pd = f.getParam(ix)
}

/**
 * An uncontrolled format string sink that is determined by imprecise methods.
 */
class HeuristicUncontrolledFormatStringSink extends UncontrolledFormatStringSink {
  HeuristicUncontrolledFormatStringSink() {
    exists(Callable f, Type argsType |
      (
        // by parameter name
        exists(CallExpr ce, int ix |
          formatLikeHeuristic(f, ix, _) and
          f = ce.getStaticTarget() and
          this.asExpr() = ce.getArgument(ix).getExpr()
        )
        or
        // by argument name
        exists(Argument a |
          a.getLabel() = ["format", "formatString", "fmt"] and
          a.getApplyExpr().getStaticTarget() = f and
          this.asExpr() = a.getExpr()
        )
      ) and
      // last parameter is vararg
      argsType = f.getParam(f.getNumberOfParams() - 1).getType().getUnderlyingType() and
      (
        argsType instanceof CVaListPointerType or
        argsType instanceof VariadicSequenceType
      )
    ) and
    // prevent overlap with `swift/predicate-injection`
    not this instanceof PredicateInjectionSink
  }
}

/**
 * A barrier for uncontrolled format string vulnerabilities.
 */
private class UncontrolledFormatStringDefaultBarrier extends UncontrolledFormatStringBarrier {
  UncontrolledFormatStringDefaultBarrier() {
    // any numeric type
    this.asExpr().getType().getUnderlyingType().getABaseType*().getName() =
      ["Numeric", "SignedInteger", "UnsignedInteger"]
  }
}

// Copied from swift/ql/lib/codeql/swift/security/UncontrolledFormatStringQuery.qll.

/**
 * A taint configuration for tainted data that reaches a format string.
 */
module TaintedFormatConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof FlowSource }

  predicate isSink(DataFlow::Node node) { node instanceof UncontrolledFormatStringSink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof UncontrolledFormatStringBarrier }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(UncontrolledFormatStringAdditionalFlowStep s).step(nodeFrom, nodeTo)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Detect taint flow of tainted data that reaches a format string.
 */
module TaintedFormatFlow = TaintTracking::Global<TaintedFormatConfig>;

import TaintedFormatFlow::PathGraph

from TaintedFormatFlow::PathNode sourceNode, TaintedFormatFlow::PathNode sinkNode
where TaintedFormatFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode, "This format string depends on $@.",
  sourceNode.getNode(), "this user-provided value"
