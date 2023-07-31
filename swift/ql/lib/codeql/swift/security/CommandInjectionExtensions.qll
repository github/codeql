/**
 * Provides classes and predicates for reasoning about system
 * commands built from user-controlled sources (that is, command injection
 * vulnerabilities).
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.ExternalFlow

/**
 * A dataflow sink for command injection vulnerabilities.
 */
abstract class CommandInjectionSink extends DataFlow::Node { }

/**
 * A barrier for command injection vulnerabilities.
 */
abstract class CommandInjectionBarrier extends DataFlow::Node { }

/**
 * A unit class for adding additional flow steps.
 */
class CommandInjectionAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step for paths related to command injection vulnerabilities.
   */
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

/**
 * An additional taint step for command injection vulnerabilities.
 */
private class CommandInjectionArrayAdditionalFlowStep extends CommandInjectionAdditionalFlowStep {
  override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    // needed until we have proper content flow through arrays.
    exists(ArrayExpr arr |
      nodeFrom.asExpr() = arr.getAnElement() and
      nodeTo.asExpr() = arr
    )
  }
}

/**
 * A `DataFlow::Node` that is written into a `Process` object.
 */
private class ProcessSink extends CommandInjectionSink instanceof DataFlow::Node {
  ProcessSink() {
    // any write into a class derived from `Process` is a sink. For
    // example in `Process.launchPath = sensitive` the post-update node corresponding
    // with `Process.launchPath` is a sink.
    exists(NominalType t, Expr e |
      t.getABaseType*().getUnderlyingType().getName() = "Process" and
      this.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr() = e and
      e.getFullyConverted().getType() = t and
      not e.(DeclRefExpr).getDecl() instanceof SelfParamDecl
    )
  }
}

/**
 * A sink defined in a CSV model.
 */
private class DefaultCommandInjectionSink extends CommandInjectionSink {
  DefaultCommandInjectionSink() { sinkNode(this, "command-injection") }
}
