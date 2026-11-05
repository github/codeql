/**
 * Provides classes and predicates for reasoning about command injection
 * vulnerabilities (CWE-078).
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.FlowSink
private import codeql.rust.dataflow.FlowBarrier
private import codeql.rust.Concepts
private import codeql.rust.security.Barriers as Barriers

/**
 * Provides default sources, sinks and barriers for detecting command injection
 * vulnerabilities, as well as extension points for adding your own.
 */
module CommandInjection {
  /**
   * A data flow source for command injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for command injection vulnerabilities.
   */
  abstract class Sink extends QuerySink::Range {
    override string getSinkType() { result = "CommandInjection" }
  }

  /**
   * A barrier for command injection vulnerabilities.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

  /**
   * A sink for command injection from model data.
   */
  private class ModelsAsDataSink extends Sink {
    ModelsAsDataSink() { sinkNode(this, "command-injection") }
  }

  /**
   * A barrier for command injection from model data.
   */
  private class ModelsAsDataBarrier extends Barrier {
    ModelsAsDataBarrier() { barrierNode(this, "command-injection") }
  }

  /**
   * A barrier for command injection vulnerabilities for nodes whose type is a
   * numeric type, which is unlikely to expose any vulnerability.
   */
  private class NumericTypeBarrier extends Barrier instanceof Barriers::NumericTypeBarrier { }

  private class BooleanTypeBarrier extends Barrier instanceof Barriers::BooleanTypeBarrier { }

  private class FieldlessEnumTypeBarrier extends Barrier instanceof Barriers::FieldlessEnumTypeBarrier
  { }

  /**
   * A sanitizer guard for command injection vulnerabilities.
   */
  class SanitizerGuard extends Barrier {
    SanitizerGuard() { this = DataFlow::BarrierGuard<sanitizerGuard/3>::getABarrierNode() }
  }
}

private predicate sanitizerGuard(AstNode g, Expr e, boolean branch) {
  g.(SanitizerGuard::Range).checks(e, branch)
}

/**
 * Provides a class for modeling new command injection safety checks.
 */
module SanitizerGuard {
  /**
   * A data-flow node that checks whether a command is safe.
   */
  abstract class Range extends AstNode {
    /**
     * Holds if this guard validates `e` upon evaluating to `branch`.
     */
    abstract predicate checks(Expr e, boolean branch);
  }
}

/**
 * A successful membership check against a (presumed) command allowlist. For example:
 * ```
 * if allowlist.contains(&commmand) { ... }
 * ```
 */
private class AllowlistContainsCheck extends SanitizerGuard::Range, MethodCall {
  AllowlistContainsCheck() { this.getStaticTarget().getName().getText() = "contains" }

  override predicate checks(Expr e, boolean branch) {
    e.getParentNode*() = this.getPositionalArgument(0) and
    branch = true
  }
}

/**
 * An equality check against a (presumed) allowed command value. For example:
 * ```
 * if command == "ls" { ... }
 * ```
 */
private class AllowlistEqualityCheck extends SanitizerGuard::Range, EqualityOperation {
  override predicate checks(Expr e, boolean branch) {
    e = this.getAnOperand() and
    (
      this instanceof EqualsOperation and branch = true
      or
      this instanceof NotEqualsOperation and branch = false
    )
  }
}
