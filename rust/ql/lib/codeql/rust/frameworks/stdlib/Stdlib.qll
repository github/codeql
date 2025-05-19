/**
 * Provides classes modeling security-relevant aspects of the standard libraries.
 */

private import rust
private import codeql.rust.Concepts
private import codeql.rust.controlflow.ControlFlowGraph as Cfg
private import codeql.rust.controlflow.CfgNodes as CfgNodes
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.internal.PathResolution

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
 * The [`Option` enum][1].
 *
 * [1]: https://doc.rust-lang.org/std/option/enum.Option.html
 */
class OptionEnum extends Enum {
  OptionEnum() {
    // todo: replace with canonical path, once calculated in QL
    exists(Crate core, Module m |
      core.getName() = "core" and
      m = core.getSourceFile().(ItemNode).getASuccessor("option") and
      this = m.(ItemNode).getASuccessor("Option")
    )
  }

  /** Gets the `Some` variant. */
  Variant getSome() { result = this.getVariant("Some") }
}

/**
 * The [`Result` enum][1].
 *
 * [1]: https://doc.rust-lang.org/stable/std/result/enum.Result.html
 */
class ResultEnum extends Enum {
  ResultEnum() {
    // todo: replace with canonical path, once calculated in QL
    exists(Crate core, Module m |
      core.getName() = "core" and
      m = core.getSourceFile().(ItemNode).getASuccessor("result") and
      this = m.(ItemNode).getASuccessor("Result")
    )
  }

  /** Gets the `Ok` variant. */
  Variant getOk() { result = this.getVariant("Ok") }

  /** Gets the `Err` variant. */
  Variant getErr() { result = this.getVariant("Err") }
}
