/** Provides classes representing the control flow graph. */

private import codeql.Locations
private import codeql.ruby.AST
private import codeql.ruby.controlflow.BasicBlocks
private import SuccessorTypes
private import internal.ControlFlowGraphImpl
private import internal.Splitting
private import internal.Completion

/** An AST node with an associated control-flow graph. */
class CfgScope extends Scope instanceof CfgScope::Range_ {
  /** Gets the CFG scope that this scope is nested under, if any. */
  final CfgScope getOuterCfgScope() {
    exists(AstNode parent |
      parent = this.getParent() and
      result = getCfgScope(parent)
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
class CfgNode extends TCfgNode {
  /** Gets a textual representation of this control flow node. */
  string toString() { none() }

  /** Gets the AST node that this node corresponds to, if any. */
  AstNode getNode() { none() }

  /** Gets the location of this control flow node. */
  Location getLocation() { none() }

  /** Gets the file of this control flow node. */
  final File getFile() { result = this.getLocation().getFile() }

  /** Holds if this control flow node has conditional successors. */
  final predicate isCondition() { exists(this.getASuccessor(any(BooleanSuccessor bs))) }

  /** Gets the scope of this node. */
  final CfgScope getScope() { result = getNodeCfgScope(this) }

  /** Gets the basic block that this control flow node belongs to. */
  BasicBlock getBasicBlock() { result.getANode() = this }

  /** Gets a successor node of a given type, if any. */
  final CfgNode getASuccessor(SuccessorType t) { result = getASuccessor(this, t) }

  /** Gets an immediate successor, if any. */
  final CfgNode getASuccessor() { result = this.getASuccessor(_) }

  /** Gets an immediate predecessor node of a given flow type, if any. */
  final CfgNode getAPredecessor(SuccessorType t) { result.getASuccessor(t) = this }

  /** Gets an immediate predecessor, if any. */
  final CfgNode getAPredecessor() { result = this.getAPredecessor(_) }

  /** Holds if this node has more than one predecessor. */
  final predicate isJoin() { strictcount(this.getAPredecessor()) > 1 }

  /** Holds if this node has more than one successor. */
  final predicate isBranch() { strictcount(this.getASuccessor()) > 1 }
}

/** The type of a control flow successor. */
class SuccessorType extends TSuccessorType {
  /** Gets a textual representation of successor type. */
  string toString() { none() }
}

/** Provides different types of control flow successor types. */
module SuccessorTypes {
  /** A normal control flow successor. */
  class NormalSuccessor extends SuccessorType, TSuccessorSuccessor {
    final override string toString() { result = "successor" }
  }

  /**
   * A conditional control flow successor. Either a Boolean successor (`BooleanSuccessor`),
   * an emptiness successor (`EmptinessSuccessor`), or a matching successor
   * (`MatchingSuccessor`)
   */
  class ConditionalSuccessor extends SuccessorType {
    boolean value;

    ConditionalSuccessor() {
      this = TBooleanSuccessor(value) or
      this = TEmptinessSuccessor(value) or
      this = TMatchingSuccessor(value)
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
  class BooleanSuccessor extends ConditionalSuccessor, TBooleanSuccessor { }

  /**
   * An emptiness control flow successor.
   *
   * For example, this program fragment:
   *
   * ```rb
   * for arg in args do
   *   puts arg
   * end
   * puts "done";
   * ```
   *
   * has a control flow graph containing emptiness successors:
   *
   * ```
   *           args
   *            |
   *          for------<-----
   *           / \           \
   *          /   \          |
   *         /     \         |
   *        /       \        |
   *     empty    non-empty  |
   *       |          \      |
   *  puts "done"      \     |
   *                  arg    |
   *                    |    |
   *                puts arg |
   *                     \___/
   * ```
   */
  class EmptinessSuccessor extends ConditionalSuccessor, TEmptinessSuccessor {
    override string toString() { if value = true then result = "empty" else result = "non-empty" }
  }

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
  class MatchingSuccessor extends ConditionalSuccessor, TMatchingSuccessor {
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
  class ReturnSuccessor extends SuccessorType, TReturnSuccessor {
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
  class BreakSuccessor extends SuccessorType, TBreakSuccessor {
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
  class NextSuccessor extends SuccessorType, TNextSuccessor {
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
  class RedoSuccessor extends SuccessorType, TRedoSuccessor {
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
  class RetrySuccessor extends SuccessorType, TRetrySuccessor {
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
  class RaiseSuccessor extends SuccessorType, TRaiseSuccessor {
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
  class ExitSuccessor extends SuccessorType, TExitSuccessor {
    final override string toString() { result = "exit" }
  }
}
