/**
 * Provides classes and predicates for reasoning about uncontrolled
 * format string vulnerabilities.
 */

import swift
private import codeql.swift.StringFormat
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.TaintTracking
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.frameworks.StandardLibrary.PointerTypes
private import codeql.swift.security.PredicateInjectionExtensions

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
