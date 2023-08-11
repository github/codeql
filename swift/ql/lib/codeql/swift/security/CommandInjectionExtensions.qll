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

private class ProcessSink2 extends CommandInjectionSink instanceof DataFlow::Node {
  ProcessSink2() {
    exists(AssignExpr assign, ProcessHost s |
      assign.getDest() = s and
      this.asExpr() = assign.getSource()
    )
    or
    exists(AssignExpr assign, ProcessHost s, ArrayExpr a |
      assign.getDest() = s and
      a = assign.getSource() and
      this.asExpr() = a.getAnElement()
    )
  }
}

private class ProcessHost extends MemberRefExpr {
  ProcessHost() { this.getBase() instanceof ProcessRef }
}

/** An expression of type `Process`. */
private class ProcessRef extends Expr {
  ProcessRef() {
    this.getType() instanceof ProcessType or
    this.getType() = any(OptionalType t | t.getBaseType() instanceof ProcessType)
  }
}

/** The type `Process`. */
private class ProcessType extends NominalType {
  ProcessType() { this.getFullName() = "Process" }
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
      e.getFullyConverted() = this.asExpr() and
      e.getFullyConverted().getType() = t
    )
  }
}

/**
 * A sink defined in a CSV model.
 */
private class DefaultCommandInjectionSink extends CommandInjectionSink {
  DefaultCommandInjectionSink() { sinkNode(this, "command-injection") }
}
