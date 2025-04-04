/** Provides classes and predicates to reason about path injection vulnerabilities. */

import rust
private import codeql.rust.controlflow.BasicBlocks
private import codeql.rust.controlflow.ControlFlowGraph
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.TaintTracking
private import codeql.rust.Concepts
private import codeql.rust.dataflow.internal.DataFlowImpl
private import codeql.rust.controlflow.ControlFlowGraph as Cfg
private import codeql.rust.controlflow.CfgNodes as CfgNodes

/**
 * Provides default sources, sinks and barriers for detecting path injection
 * vulnerabilities, as well as extension points for adding your own.
 */
module TaintedPath {
  /**
   * A data flow source for path injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for path injection vulnerabilities.
   */
  abstract class Sink extends QuerySink::Range {
    override string getSinkType() { result = "TaintedPath" }
  }

  /**
   * A barrier for path injection vulnerabilities.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * A sanitizer guard for path-traversal vulnerabilities.
   */
  class SanitizerGuard extends DataFlow::Node {
    SanitizerGuard() { this = DataFlow::BarrierGuard<sanitizerGuard/3>::getABarrierNode() }
  }

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

  /** A sink for path-injection from model data. */
  private class ModelsAsDataSinks extends Sink {
    ModelsAsDataSinks() { sinkNode(this, "path-injection") }
  }
}

private predicate sanitizerGuard(CfgNodes::AstCfgNode g, Cfg::CfgNode node, boolean branch) {
  g.(SanitizerGuard::Range).checks(node, branch)
}

/** Provides a class for modeling new path safety checks. */
module SanitizerGuard {
  /** A data-flow node that checks that a path is safe to access. */
  abstract class Range extends CfgNodes::AstCfgNode {
    /** Holds if this guard validates `node` upon evaluating to `branch`. */
    abstract predicate checks(Cfg::CfgNode node, boolean branch);
  }
}

/**
 * A check of the form `!strings.Contains(nd, "..")`, considered as a sanitizer guard for
 * path traversal.
 */
private class DotDotCheck extends SanitizerGuard::Range, CfgNodes::MethodCallExprCfgNode {
  DotDotCheck() {
    this.getAstNode().(Resolvable).getResolvedPath() = "<str>::contains" and
    this.getArgument(0).getAstNode().(LiteralExpr).getTextValue() =
      ["\"..\"", "\"../\"", "\"..\\\""]
  }

  override predicate checks(Cfg::CfgNode e, boolean branch) {
    e = this.getReceiver() and
    branch = false
  }
}
