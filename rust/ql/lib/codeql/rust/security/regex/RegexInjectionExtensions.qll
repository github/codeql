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
 * Provides default sources, sinks and barriers for detecting regular expression
 * injection vulnerabilities, as well as extension points for adding your own.
 */
module RegexInjection {
  /**
   * A data flow source for regular expression injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for regular expression injection vulnerabilities.
   */
  abstract class Sink extends QuerySink::Range {
    override string getSinkType() { result = "RegexInjection" }
  }

  /**
   * A barrier for regular expression injection vulnerabilities.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * A unit class for adding additional flow steps.
   */
  class AdditionalFlowStep extends Unit {
    /**
     * Holds if the step from `node1` to `node2` should be considered a flow
     * step for paths related to regular expression injection vulnerabilities.
     */
    abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
  }

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

  /**
   * A sink for `a` in `Regex::new(a)` when `a` is not a literal.
   */
  private class NewSink extends Sink {
    NewSink() {
      exists(CallExprCfgNode call, PathExpr path |
        path = call.getFunction().getExpr() and
        path.getResolvedCrateOrigin() = "repo:https://github.com/rust-lang/regex:regex" and
        path.getResolvedPath() = "<crate::regex::string::Regex>::new" and
        this.asExpr() = call.getArgument(0) and
        not this.asExpr() instanceof LiteralExprCfgNode
      )
    }
  }

  /**
   * A sink for regular expression injection from model data.
   */
  private class ModelsAsDataSink extends Sink {
    ModelsAsDataSink() { sinkNode(this, "regex-use") }
  }

  /**
   * An escape barrier for regular expression injection vulnerabilities.
   */
  private class DefaultBarrier extends Barrier {
    DefaultBarrier() {
      // A barrier is any call to a function named `escape`, in particular this
      // makes calls to `regex::escape` a barrier.
      this.asExpr()
          .getExpr()
          .(CallExpr)
          .getFunction()
          .(PathExpr)
          .getPath()
          .getSegment()
          .getIdentifier()
          .getText() = "escape"
    }
  }
}
