/**
 * Provides subclasses of `CfgNode` that represents different types of nodes in
 * the control flow graph.
 */

private import rust
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
 * A record expression. For example:
 * ```rust
 * let first = Foo { a: 1, b: 2 };
 * let second = Foo { a: 2, ..first };
 * Foo { a: 1, b: 2 }[2] = 10;
 * Foo { .. } = second;
 * ```
 */
final class RecordExprCfgNode extends Nodes::RecordExprCfgNode {
  private RecordExprChildMapping node;

  RecordExprCfgNode() { node = this.getRecordExpr() }

  /** Gets the `i`th record expression. */
  ExprCfgNode getExpr(int i) {
    any(ChildMapping mapping)
        .hasCfgChild(node, node.getRecordExprFieldList().getField(i).getExpr(), this, result)
  }
}
