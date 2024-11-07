/** Provides classes representing the control flow graph. */

private import codeql.ruby.AST
private import codeql.ruby.controlflow.BasicBlocks
private import SuccessorTypes
private import internal.ControlFlowGraphImpl as CfgImpl
private import internal.Splitting as Splitting
private import internal.Completion

/**
 * An AST node with an associated control-flow graph.
 *
 * Top-levels, methods, blocks, and lambdas are all CFG scopes.
 *
 * Note that module declarations are not themselves CFG scopes, as they are part of
 * the CFG of the enclosing top-level or callable.
 */
class CfgScope extends Scope instanceof CfgImpl::CfgScopeImpl {
  /** Gets the CFG scope that this scope is nested under, if any. */
  final CfgScope getOuterCfgScope() {
    exists(AstNode parent |
      parent = this.getParent() and
      result = CfgImpl::getCfgScope(parent)
    )
  }
}

/**
 * A control flow node.
 *
 * A control flow node is a node in the control flow graph (CFG). There is a
 * many-to-one relationship between CFG nodes and AST nodes.
 *
 * Only nodes that can be reached from an entry point are included in the CFG.
 */
class CfgNode extends CfgImpl::Node {
  /** Gets the name of the primary QL class for this node. */
  string getAPrimaryQlClass() { none() }

  /** Gets the file of this control flow node. */
  final File getFile() { result = this.getLocation().getFile() }

  /** Gets a successor node of a given type, if any. */
  final CfgNode getASuccessor(SuccessorType t) { result = super.getASuccessor(t) }

  /** Gets an immediate successor, if any. */
  final CfgNode getASuccessor() { result = this.getASuccessor(_) }

  /** Gets an immediate predecessor node of a given flow type, if any. */
  final CfgNode getAPredecessor(SuccessorType t) { result.getASuccessor(t) = this }

  /** Gets an immediate predecessor, if any. */
  final CfgNode getAPredecessor() { result = this.getAPredecessor(_) }

  /** Gets the basic block that this control flow node belongs to. */
  BasicBlock getBasicBlock() { result.getANode() = this }
}

/** The type of a control flow successor. */
class SuccessorType extends CfgImpl::TSuccessorType {
  /** Gets a textual representation of successor type. */
  string toString() { none() }
}

/** Provides different types of control flow successor types. */
module SuccessorTypes {
  /** A normal control flow successor. */
  class NormalSuccessor extends SuccessorType, CfgImpl::TSuccessorSuccessor {
    final override string toString() { result = "successor" }
  }

  /**
   * A conditional control flow successor. Either a Boolean successor (`BooleanSuccessor`)
   * or a matching successor (`MatchingSuccessor`)
   */
  class ConditionalSuccessor extends SuccessorType {
    boolean value;

    ConditionalSuccessor() {
      this = CfgImpl::TBooleanSuccessor(value) or
      this = CfgImpl::TMatchingSuccessor(value)
    }

    /** Gets the Boolean value of this successor. */
    final boolean getValue() { result = value }

    override string toString() { result = this.getValue().toString() }
  }

  /**
   * A Boolean control flow successor.
   *
   * For example, in
   *
   * ```rb
   * if x >= 0
   *   puts "positive"
   * else
   *   puts "negative"
   * end
   * ```
   *
   * `x >= 0` has both a `true` successor and a `false` successor.
   */
  class BooleanSuccessor extends ConditionalSuccessor, CfgImpl::TBooleanSuccessor { }

  /**
   * A matching control flow successor.
   *
   * For example, this program fragment:
   *
   * ```rb
   * case x
   *   when 1 then puts "one"
   *   else puts "not one"
   * end
   * ```
   *
   * has a control flow graph containing matching successors:
   *
   * ```
   *            x
   *            |
   *            1
   *           / \
   *          /   \
   *         /     \
   *        /       \
   *     match    non-match
   *       |          |
   *  puts "one"  puts "not one"
   * ```
   */
  class MatchingSuccessor extends ConditionalSuccessor, CfgImpl::TMatchingSuccessor {
    override string toString() { if value = true then result = "match" else result = "no-match" }
  }

  /**
   * A `return` control flow successor.
   *
   * Example:
   *
   * ```rb
   * def sum(x,y)
   *   return x + y
   * end
   * ```
   *
   * The exit node of `sum` is a `return` successor of the `return x + y`
   * statement.
   */
  class ReturnSuccessor extends SuccessorType, CfgImpl::TReturnSuccessor {
    final override string toString() { result = "return" }
  }

  /**
   * A `break` control flow successor.
   *
   * Example:
   *
   * ```rb
   * def m
   *   while x >= 0
   *     x -= 1
   *     if num > 100
   *       break
   *     end
   *   end
   *   puts "done"
   * end
   * ```
   *
   * The node `puts "done"` is `break` successor of the node `break`.
   */
  class BreakSuccessor extends SuccessorType, CfgImpl::TBreakSuccessor {
    final override string toString() { result = "break" }
  }

  /**
   * A `next` control flow successor.
   *
   * Example:
   *
   * ```rb
   * def m
   *   while x >= 0
   *     x -= 1
   *     if num > 100
   *       next
   *     end
   *   end
   *   puts "done"
   * end
   * ```
   *
   * The node `x >= 0` is `next` successor of the node `next`.
   */
  class NextSuccessor extends SuccessorType, CfgImpl::TNextSuccessor {
    final override string toString() { result = "next" }
  }

  /**
   * A `redo` control flow successor.
   *
   * Example:
   *
   * Example:
   *
   * ```rb
   * def m
   *   while x >= 0
   *     x -= 1
   *     if num > 100
   *       redo
   *     end
   *   end
   *   puts "done"
   * end
   * ```
   *
   * The node `x -= 1` is `redo` successor of the node `redo`.
   */
  class RedoSuccessor extends SuccessorType, CfgImpl::TRedoSuccessor {
    final override string toString() { result = "redo" }
  }

  /**
   * A `retry` control flow successor.
   *
   * Example:
   *
   * Example:
   *
   * ```rb
   * def m
   *   begin
   *     puts "Retry"
   *     raise
   *   rescue
   *     retry
   *   end
   * end
   * ```
   *
   * The node `puts "Retry"` is `retry` successor of the node `retry`.
   */
  class RetrySuccessor extends SuccessorType, CfgImpl::TRetrySuccessor {
    final override string toString() { result = "retry" }
  }

  /**
   * An exceptional control flow successor.
   *
   * Example:
   *
   * ```rb
   * def m x
   *   if x > 2
   *     raise "x > 2"
   *   end
   *   puts "x <= 2"
   * end
   * ```
   *
   * The exit node of `m` is an exceptional successor of the node
   * `raise "x > 2"`.
   */
  class RaiseSuccessor extends SuccessorType, CfgImpl::TRaiseSuccessor {
    final override string toString() { result = "raise" }
  }

  /**
   * An exit control flow successor.
   *
   * Example:
   *
   * ```rb
   * def m x
   *   if x > 2
   *     exit 1
   *   end
   *   puts "x <= 2"
   * end
   * ```
   *
   * The exit node of `m` is an exit successor of the node
   * `exit 1`.
   */
  class ExitSuccessor extends SuccessorType, CfgImpl::TExitSuccessor {
    final override string toString() { result = "exit" }
  }
}

class Split = Splitting::Split;

/** Provides different kinds of control flow graph splittings. */
module Split {
  class ConditionalCompletionSplit = Splitting::ConditionalCompletionSplit;
}
