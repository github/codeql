/**
 * Provides classes modeling security-relevant aspects of the standard libraries.
 */

private import rust
private import codeql.rust.Concepts
private import codeql.rust.controlflow.ControlFlowGraph as Cfg
private import codeql.rust.controlflow.CfgNodes as CfgNodes
private import codeql.rust.dataflow.DataFlow

/**
 * A call to the `starts_with` method on a `Path`.
 */
private class StartswithCall extends Path::SafeAccessCheck::Range, CfgNodes::MethodCallExprCfgNode {
  StartswithCall() {
    this.getAstNode().(Resolvable).getResolvedPath() = "<crate::path::Path>::starts_with"
  }

  override predicate checks(Cfg::CfgNode e, boolean branch) {
    e = this.getReceiver() and
    branch = true
  }
}

/**
 * A call to `Path.canonicalize`.
 * See https://doc.rust-lang.org/std/path/struct.Path.html#method.canonicalize
 */
private class PathCanonicalizeCall extends Path::PathNormalization::Range {
  CfgNodes::MethodCallExprCfgNode call;

  PathCanonicalizeCall() {
    call = this.asExpr() and
    call.getAstNode().(Resolvable).getResolvedPath() = "<crate::path::Path>::canonicalize"
  }

  override DataFlow::Node getPathArg() { result.asExpr() = call.getReceiver() }
}
