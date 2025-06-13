/**
 * Provides subclasses of `CfgNode` that represents different types of nodes in
 * the control flow graph.
 */

private import rust
private import codeql.rust.elements.Call
private import ControlFlowGraph
private import internal.ControlFlowGraphImpl as CfgImpl
private import internal.CfgNodes
import Nodes

class AstCfgNode = CfgImpl::AstCfgNode;

class ExitCfgNode = CfgImpl::ExitNode;

class AnnotatedExitCfgNode = CfgImpl::AnnotatedExitNode;

/**
 * An assignment expression, for example
 *
 * ```rust
 * x = y;
 * ```
 */
final class AssignmentExprCfgNode extends BinaryExprCfgNode {
  AssignmentExpr a;

  AssignmentExprCfgNode() { a = this.getBinaryExpr() }

  /** Gets the underlying `AssignmentExpr`. */
  AssignmentExpr getAssignmentExpr() { result = a }
}

/**
 * A match expression. For example:
 * ```rust
 * match x {
 *     Option::Some(y) => y,
 *     Option::None => 0,
 * }
 * ```
 * ```rust
 * match x {
 *     Some(y) if y != 0 => 1 / y,
 *     _ => 0,
 * }
 * ```
 */
final class MatchExprCfgNode extends Nodes::MatchExprCfgNode {
  private MatchExpr node;

  MatchExprCfgNode() { node = this.getMatchExpr() }

  /**
   * Gets the pattern of the `i`th match arm, if it exists.
   */
  PatCfgNode getArmPat(int i) {
    any(ChildMapping mapping).hasCfgChild(node, node.getArm(i).getPat(), this, result)
  }

  /**
   * Gets the guard of the `i`th match arm, if it exists.
   */
  ExprCfgNode getArmGuard(int i) {
    any(ChildMapping mapping)
        .hasCfgChild(node, node.getArm(i).getGuard().getCondition(), this, result)
  }

  /**
   * Gets the expression of the `i`th match arm, if it exists.
   */
  ExprCfgNode getArmExpr(int i) {
    any(ChildMapping mapping).hasCfgChild(node, node.getArm(i).getExpr(), this, result)
  }
}

/**
 * A block expression. For example:
 * ```rust
 * {
 *     let x = 42;
 * }
 * ```
 * ```rust
 * 'label: {
 *     let x = 42;
 *     x
 * }
 * ```
 */
final class BlockExprCfgNode extends Nodes::BlockExprCfgNode {
  private BlockExprChildMapping node;

  BlockExprCfgNode() { node = this.getAstNode() }

  /**
   * Gets the tail expression of this block, if it exists.
   */
  ExprCfgNode getTailExpr() {
    any(ChildMapping mapping).hasCfgChild(node, node.getStmtList().getTailExpr(), this, result)
  }
}

/**
 * A break expression. For example:
 * ```rust
 * loop {
 *     if not_ready() {
 *         break;
 *      }
 * }
 * ```
 * ```rust
 * let x = 'label: loop {
 *     if done() {
 *         break 'label 42;
 *     }
 * };
 * ```
 * ```rust
 * let x = 'label: {
 *     if exit() {
 *         break 'label 42;
 *     }
 *     0;
 * };
 * ```
 */
final class BreakExprCfgNode extends Nodes::BreakExprCfgNode {
  /**
   * Gets the target of this `break` expression.
   *
   * The target is either a `LoopExpr`, a `ForExpr`, a `WhileExpr`, or a
   * `BlockExpr`.
   */
  ExprCfgNode getTarget() {
    any(ChildMapping mapping)
        .hasCfgChild(this.getBreakExpr().getTarget(), this.getBreakExpr(), result, this)
  }
}

/**
 * A function or method call expression. See `CallExpr` and `MethodCallExpr` for further details.
 */
final class CallExprBaseCfgNode extends Nodes::CallExprBaseCfgNode {
  private CallExprBaseChildMapping node;

  CallExprBaseCfgNode() { node = this.getAstNode() }

  /** Gets the `i`th argument of this call. */
  ExprCfgNode getArgument(int i) {
    any(ChildMapping mapping).hasCfgChild(node, node.getArgList().getArg(i), this, result)
  }
}

/**
 * A method call expression. For example:
 * ```rust
 * x.foo(42);
 * x.foo::<u32, u64>(42);
 * ```
 */
final class MethodCallExprCfgNode extends CallExprBaseCfgNode, Nodes::MethodCallExprCfgNode { }

/**
 * A CFG node that calls a function.
 *
 * This class abstract over the different ways in which a function can be called in Rust.
 */
final class CallCfgNode extends ExprCfgNode {
  private Call node;

  CallCfgNode() { node = this.getAstNode() }

  /** Gets the underlying `Call`. */
  Call getCall() { result = node }

  /** Gets the receiver of this call if it is a method call. */
  ExprCfgNode getReceiver() {
    any(ChildMapping mapping).hasCfgChild(node, node.getReceiver(), this, result)
  }

  /** Gets the `i`th argument of this call, if any. */
  ExprCfgNode getArgument(int i) {
    any(ChildMapping mapping).hasCfgChild(node, node.getArgument(i), this, result)
  }
}

/**
 * A function call expression. For example:
 * ```rust
 * foo(42);
 * foo::<u32, u64>(42);
 * foo[0](42);
 * foo(1) = 4;
 * ```
 */
final class CallExprCfgNode extends CallExprBaseCfgNode, Nodes::CallExprCfgNode { }

/**
 * A FormatArgsExpr. For example:
 * ```rust
 * format_args!("no args");
 * format_args!("{} foo {:?}", 1, 2);
 * format_args!("{b} foo {a:?}", a=1, b=2);
 * let (x, y) = (1, 42);
 * format_args!("{x}, {y}");
 * ```
 */
final class FormatArgsExprCfgNode extends Nodes::FormatArgsExprCfgNode {
  private FormatArgsExprChildMapping node;

  FormatArgsExprCfgNode() { node = this.getAstNode() }

  /** Gets the `i`th argument of this format arguments expression (0-based). */
  ExprCfgNode getArgumentExpr(int i) {
    any(ChildMapping mapping).hasCfgChild(node, node.getArg(i).getExpr(), this, result)
  }

  /** Gets a format argument of the `i`th format of this format arguments expression (0-based). */
  FormatTemplateVariableAccessCfgNode getFormatTemplateVariableAccess(int i) {
    exists(FormatTemplateVariableAccess v, Format f |
      f = node.getFormat(i) and
      v.getArgument() = [f.getArgumentRef(), f.getWidthArgument(), f.getPrecisionArgument()] and
      result.getFormatTemplateVariableAccess() = v and
      any(ChildMapping mapping).hasCfgChild(node, v, this, result)
    )
  }
}

/**
 * A MacroCall. For example:
 * ```rust
 * todo!()
 * ```
 */
final class MacroCallCfgNode extends Nodes::MacroCallCfgNode {
  private MacroCallChildMapping node;

  MacroCallCfgNode() { node = this.getAstNode() }

  /** Gets the CFG node for the expansion of this macro call, if it exists. */
  CfgNode getExpandedNode() {
    any(ChildMapping mapping).hasCfgChild(node, node.getMacroCallExpansion(), this, result)
  }
}

/**
 * A record expression. For example:
 * ```rust
 * let first = Foo { a: 1, b: 2 };
 * let second = Foo { a: 2, ..first };
 * Foo { a: 1, b: 2 }[2] = 10;
 * Foo { .. } = second;
 * ```
 */
final class StructExprCfgNode extends Nodes::StructExprCfgNode {
  private StructExprChildMapping node;

  StructExprCfgNode() { node = this.getStructExpr() }

  /** Gets the record expression for the field `field`. */
  pragma[nomagic]
  ExprCfgNode getFieldExpr(string field) {
    exists(StructExprField ref |
      ref = node.getFieldExpr(field) and
      any(ChildMapping mapping).hasCfgChild(node, ref.getExpr(), this, result)
    )
  }
}

/**
 * A record pattern. For example:
 * ```rust
 * match x {
 *     Foo { a: 1, b: 2 } => "ok",
 *     Foo { .. } => "fail",
 * }
 * ```
 */
final class StructPatCfgNode extends Nodes::StructPatCfgNode {
  private StructPatChildMapping node;

  StructPatCfgNode() { node = this.getStructPat() }

  /** Gets the record pattern for the field `field`. */
  pragma[nomagic]
  PatCfgNode getFieldPat(string field) {
    exists(StructPatField rpf |
      rpf = node.getStructPatFieldList().getAField() and
      any(ChildMapping mapping).hasCfgChild(node, rpf.getPat(), this, result) and
      field = rpf.getFieldName()
    )
  }
}
