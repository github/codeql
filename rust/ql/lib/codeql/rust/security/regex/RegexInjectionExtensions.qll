/**
 * Provides classes and predicates to reason about regular expression injection
 * vulnerabilities.
 */

private import codeql.util.Unit
private import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.controlflow.CfgNodes
private import codeql.rust.dataflow.FlowSink
private import codeql.rust.Concepts

/**
 * A data flow sink for regular expression injection vulnerabilities.
 */
abstract class RegexInjectionSink extends QuerySink::Range {
  override string getSinkType() { result = "RegexInjection" }
}

/**
 * A barrier for regular expression injection vulnerabilities.
 */
abstract class RegexInjectionBarrier extends DataFlow::Node { }

/** A sink for `a` in `Regex::new(a)` when `a` is not a literal. */
private class NewRegexInjectionSink extends RegexInjectionSink {
  NewRegexInjectionSink() {
    exists(CallExprCfgNode call, PathExpr path |
      path = call.getFunction().getExpr() and
      path.getResolvedCrateOrigin() = "repo:https://github.com/rust-lang/regex:regex" and
      path.getResolvedPath() = "<crate::regex::string::Regex>::new" and
      this.asExpr() = call.getArgument(0) and
      not this.asExpr() instanceof LiteralExprCfgNode
    )
  }
}

private class MadRegexInjectionSink extends RegexInjectionSink {
  MadRegexInjectionSink() { sinkNode(this, "regex-use") }
}

/**
 * A unit class for adding additional flow steps.
 */
class RegexInjectionAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step for paths related to regular expression injection vulnerabilities.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

/**
 * An escape barrier for regular expression injection vulnerabilities.
 */
private class RegexInjectionDefaultBarrier extends RegexInjectionBarrier {
  RegexInjectionDefaultBarrier() {
    // A barrier is any call to a function named `escape`, in particular this
    // makes calls to `regex::escape` a barrier.
    this.asExpr()
        .getExpr()
        .(CallExpr)
        .getFunction()
        .(PathExpr)
        .getPath()
        .getPart()
        .getNameRef()
        .getText() = "escape"
  }
}
