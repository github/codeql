/**
 * Provides classes for working with a CFG-based program representation.
 *
 * ## Overview
 *
 * Each `StmtContainer` (that is, function or toplevel) has an intra-procedural
 * CFG associated with it, which is composed of `ControlFlowNode`s under a successor
 * relation exposed by predicates `ControlFlowNode.getASuccessor()` and
 * `ControlFlowNode.getAPredecessor()`.
 *
 * Each CFG has designated entry and exit nodes with types
 * `ControlFlowEntryNode` and `ControlFlowExitNode`, respectively, which are the only two
 * subtypes of `SyntheticControlFlowNode`. All `ControlFlowNode`s that are _not_
 * `SyntheticControlFlowNode`s belong to class `ConcreteControlFlowNode`.
 *
 * The predicate `ASTNode.getFirstControlFlowNode()` relates AST nodes
 * to the first (concrete) CFG node in the sub-graph of the CFG
 * corresponding to the node.
 *
 * Most statement containers also have a _start node_, obtained by
 * `StmtContainer.getStart()`, which is the unique CFG node at which execution
 * of the toplevel or function begins. Unlike the entry node, which is a synthetic
 * construct, the start node corresponds to an AST node: for instance, for
 * toplevels, it is the first CFG node of the first statement, and for functions
 * with parameters it is the CFG node corresponding to the first parameter.
 *
 * Empty toplevels do not have a start node, since all their CFG nodes are
 * synthetic.
 *
 * ## CFG Nodes
 *
 * Non-synthetic CFG nodes exist for six kinds of AST nodes, representing various
 * aspects of the program's runtime semantics:
 *
 *   - `Expr`: the CFG node represents the evaluation of the expression,
 *      including any side effects this may have;
 *   - `Stmt`: the CFG node represents the execution of the statement;
 *   - `Property`: the CFG node represents the assignment of the property;
 *   - `PropertyPattern`: the CFG node represents the matching of the property;
 *   - `MemberDefinition`: the CFG node represents the definition of the member
 *     method or field;
 *   - `MemberSignature`: the CFG node represents the point where the signature
 *     is declared, although this has no effect at runtime.
 *
 * ## CFG Structure
 *
 * ### Expressions
 *
 * For most expressions, the successor relation visits sub-expressions first,
 * and then the expression itself, representing the order of evaluation at
 * runtime. For example, the CFG for the expression `23 + 19` is
 *
 * <pre>
 * &hellip; &rarr; [23] &rarr; [19] &rarr; [23 + 19] &rarr; &hellip;
 * </pre>
 *
 * In particular, this means that `23` is the first CFG node of the expression
 * `23 + 19`.
 *
 * Similarly, for assignments the left hand side is visited first, then
 * the right hand side, then the assignment itself:
 *
 * <pre>
 * &hellip; &rarr; [x] &rarr; [y] &rarr; [x = y] &rarr; &hellip;
 * </pre>
 *
 * For properties, the name expression is visited first, then the value,
 * then the default value, if any. The same principle applies for getter
 * and setter properties: in this case, the "value" is simply the accessor
 * function, and there is no default value.
 *
 * There are only a few exceptions, generally for cases where the value of
 * the whole expression is the value of one of its sub-expressions. That
 * sub-expression then comes last in the CFG:
 *
 *   - Parenthesized expression:
 * <pre>
 * &hellip; &rarr; [(x)] &rarr; [x] &rarr; &hellip;
 * </pre>
 *   - Conditional expressions:
 * <pre>
 * &hellip; &rarr;  [x ? y : z]  &rarr; [x] &#x252c;&rarr; [y] &rarr; &hellip; <br>
 * &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &#x2514;&rarr; [z] &rarr; &hellip;
 * </pre>
 *   - Short-circuiting operator `&&` (same for `||`):
 * <pre>
 * &hellip; &rarr; [x && y] &rarr; [x] &rarr; &hellip; <br>
 * &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &darr; <br>
 * &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [y] &rarr; &hellip;
 * </pre>
 *   - Sequence/comma expressions:
 * <pre>
 * &hellip; &rarr; [x, y] &rarr; [x] &rarr; [y] &rarr; &hellip;
 * </pre>
 *
 * Finally, array expressions and object expressions also precede their
 * sub-expressions in the CFG to model the fact that the new array/object
 * is created before its elements/properties are evaluated:
 *
 * <pre>
 * &hellip; &rarr; [{ x: 42 }] &rarr; [x] &rarr; [42] &rarr; [x : 42] &rarr; &hellip;
 * </pre>
 *
 * ### Statements
 *
 * For most statements, the successor relation visits the statement first and then
 * its sub-expressions and sub-statements.
 *
 * For example, the CFG of a block statement first visits the individual statements,
 * then the block statement itself.
 *
 * Similarly, the CFG for an `if` statement first visits the statement itself, then
 * the condition. The condition, in turn, has the "then" branch as one of its successors
 * and the "else" branch (if it exists) or the next statement after the "if" (if it does not)
 * as the other:
 *
 * <pre>
 * &hellip; &rarr; [if (x) s1 else s2] &rarr; [x] &#x252c;&rarr; [s1] &rarr; &hellip;
 * &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &#x2514;&rarr; [s2] &rarr; &hellip;
 * </pre>
 *
 * For loops, the CFG reflects the order in which the loop test and the body are
 * executed.
 *
 * For instance, the CFG of a `while` loop starts with the statement itself, followed by
 * the condition. The condition has two successors: the body, and the statement following
 * the loop. The body, in turn, has the condition as its successor. This reflects the fact
 * that `while` loops first test their condition before executing their body:
 *
 * <pre>
 * &hellip; &rarr; [while (x) s] &rarr; [x] &rarr; &hellip;
 * &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &#x21c5;
 * &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [s]
 * </pre>
 *
 * On the other hand, `do`-`while` loops first execute their body before testing their condition:
 *
 * <pre>
 * &hellip; &rarr; [do s while (x)] &rarr; [s] &#x21c4; [x] &rarr; &hellip;
 * </pre>
 *
 * The CFG of a for loop starts with the loop itself, followed by the initializer expression
 * (if any), then the test expression (if any). The test expression has two successors: the
 * body, and the statement following the loop. The body, in turn, has the update expression
 * (if any) as its successor, and the update expression has the test expression as its only
 * successor:
 *
 * <pre>
 * &hellip; &rarr; [for(i;t;u) s] &rarr; [i] &rarr; [t] &rarr; &hellip;
 * &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&#x2199;&nbsp;&#x2196
 * &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[s] &rarr; [u]
 * </pre>
 *
 * The CFG of a for-in loop `for(x in y) s` starts with the loop itself, followed by the
 * iteration domain `y`. That node has two successors: the iterator `x`, and the statement
 * following the loop (modeling early exit in case `y` is empty). After the iterator `x`
 * comes the loop body `s`, which again has two successors: the iterator `x` (modeling the
 * case where there are more elements to iterate over), and the statement following the loop
 * (modeling the case where there are no more elements to iterate):
 *
 * <pre>
 * &hellip; &rarr; [for(x in y) s] &rarr; [y] &rarr; &nbsp;&hellip;
 * &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&darr;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&uarr;
 * &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[x] &#x21c4; [s]
 * </pre>
 *
 * For-of loops are the same.
 *
 * Finally, `return` and `throw` statements are different from all other statement types in
 * that for them the statement itself comes _after_ the operand, reflecting the fact that
 * the operand is evaluated before the return or throw is initiated:
 *
 * <pre>
 * &hellip; &rarr; [x] &rarr; [return x;] &rarr; &hellip;
 * </pre>
 *
 * ### Unstructured control flow
 *
 * Unstructured control flow is modeled in the obvious way: `break` and `continue` statements
 * have as their successor the next statement that is executed after the jump; `throw`
 * statements have the nearest enclosing `catch` clause as their successor, or the exit node
 * of the enclosing container if there is no enclosing `catch`; `return` statements have the
 * exit node of the enclosing container as their successor.
 *
 * In all cases, the control flow may be intercepted by an intervening `finally` block. For
 * instance, consider the following code snippet:
 *
 * <pre>
 * try {
 * &nbsp;&nbsp;if (x)
 * &nbsp;&nbsp;&nbsp;&nbsp;return;
 * &nbsp;&nbsp;s
 * } finally {
 * &nbsp;&nbsp;t
 * }
 * u
 * </pre>
 *
 * Here, the successor of `return` is not the exit node of the enclosing container, but instead
 * the `finally` block. The last statement of the `finally` block (here, `t`) has two successors:
 * `u` to model the case where `finally` was entered from `s`, and the exit node of the enclosing
 * container to model the case where the `return` is resumed after the `finally` block.
 *
 * Note that `finally` blocks can lead to imprecise control flow modeling since the `finally`
 * block resumes the action of _all_ statements it intercepts: in the above example, the CFG
 * not only models the executions `return` &rarr; `finally` &rarr; `t` &rarr; `exit` and
 * `s` &rarr; `finally` &rarr; `t` &rarr; `u`, but also allows the path  `return` &rarr;
 * `finally` &rarr; `t` &rarr; `u`, which does not correspond to any actual execution.
 *
 * The CFG also models the fact that certain kinds of expressions (calls, `new` expressions,
 * property accesses and `await` expressions) can throw exceptions, but _only_ if there is
 * an enclosing `try`-`catch` statement.
 *
 * ### Function preambles
 *
 * The CFG of a function starts with its entry node, followed by a _preamble_, which is a part of
 * the CFG that models parameter passing and function hoisting. The preamble is followed by the
 * function body, which in turn is followed by the exit node.
 *
 * For function expressions, the preamble starts with the function name, if any, to reflect the
 * fact that the function object is bound to that name inside the scope of the function. Next,
 * for both function expressions and function declarations, the parameters are executed in sequence
 * to represent parameter passing. If a parameter has a default value, that value is visited before
 * the parameter itself. Finally, the CFG nodes corresponding to the names of all hoisted functions
 * inside the outer function body are visited in lexical order. This reflects the fact that hoisted
 * functions are initialized before the body starts executing, but _after_ parameters have been
 * initialized.
 *
 * For instance, consider the following function declaration:
 *
 * <pre>
 * function outer(x, y = 42) {
 * &nbsp;&nbsp;s
 * &nbsp;&nbsp;function inner() {}
 * &nbsp;&nbsp;t
 * }
 * </pre>
 *
 * Its CFG is
 *
 * <pre>
 * [entry] &rarr; [x] &rarr; [42] &rarr; [y] &rarr; [inner] &rarr; [s] &rarr; [function inner() {}] &rarr; [t] &rarr; [exit]
 * </pre>
 *
 * Note that the function declaration `[function inner() {}]` as a whole is part of the CFG of the
 * body of `outer`, while its function identifier `inner` is part of the preamble.
 *
 * ### Toplevel preambles
 *
 * Similar to functions, toplevels (that is, modules, scripts or event handlers) also have a
 * preamble. For ECMAScript 2015 modules, all import specifiers are traversed first, in lexical
 * order, reflecting the fact that imports are resolved before execution of the module itself
 * begins; next, for all toplevels, the names of hoisted functions are traversed in lexical order
 * (as for functions). Afterwards, the CFG continues with the body of the toplevel, and ends
 * with the exit node.
 *
 * As an example, consider the following module:
 *
 * ```
 * s
 * import x as y from 'foo';
 * function f() {}
 * t
 * ```
 *
 * Its CFG is
 *
 * <pre>
 * [entry] &rarr; [x as y] &rarr; [f] &rarr; [s] &rarr; [import x as y from 'foo';] &rarr; [function f() {}] &rarr; [t] &rarr; [exit]
 * </pre>
 *
 * Note that the `import` statement as a whole is part of the CFG of the body, while its single
 * import specifier `x as y` forms part of the preamble.
 */

import javascript
private import internal.StmtContainers

/**
 * A node in the control flow graph, which is an expression, a statement,
 * or a synthetic node.
 */
class ControlFlowNode extends @cfg_node, Locatable, NodeInStmtContainer {
  /** Gets a node succeeding this node in the CFG. */
  ControlFlowNode getASuccessor() { successor(this, result) }

  /** Gets a node preceding this node in the CFG. */
  ControlFlowNode getAPredecessor() { this = result.getASuccessor() }

  /** Holds if this is a node with more than one successor. */
  predicate isBranch() { strictcount(getASuccessor()) > 1 }

  /** Holds if this is a node with more than one predecessor. */
  predicate isJoin() { strictcount(getAPredecessor()) > 1 }

  /**
   * Holds if this is a start node, that is, the CFG node where execution of a
   * toplevel or function begins.
   */
  predicate isStart() { this = any(StmtContainer sc).getStart() }

  /**
   * Holds if this is a final node of `container`, that is, a CFG node where execution
   * of that toplevel or function terminates.
   */
  predicate isAFinalNodeOfContainer(StmtContainer container) {
    getASuccessor().(SyntheticControlFlowNode).isAFinalNodeOfContainer(container)
  }

  /**
   * Holds if this is a final node, that is, a CFG node where execution of a
   * toplevel or function terminates.
   */
  final predicate isAFinalNode() { isAFinalNodeOfContainer(_) }

  /**
   * Holds if this node is unreachable, that is, it has no predecessors in the CFG.
   * Entry nodes are always considered reachable.
   *
   * Note that in a block of unreachable code, only the first node is unreachable
   * in this sense. For instance, in
   *
   * ```
   * function foo() { return; s1; s2; }
   * ```
   *
   * `s1` is unreachable, but `s2` is not.
   */
  predicate isUnreachable() {
    forall(ControlFlowNode pred | pred = getAPredecessor() |
      pred.(SyntheticControlFlowNode).isUnreachable()
    )
    // note the override in ControlFlowEntryNode below
  }

  /** Gets the basic block this node belongs to. */
  BasicBlock getBasicBlock() { this = result.getANode() }

  /**
   * For internal use.
   *
   * Gets a string representation of this control-flow node that can help
   * distinguish it from other nodes with the same `toString` value.
   */
  string describeControlFlowNode() {
    if this = any(MethodDeclaration mem).getBody()
    then result = "function in " + any(MethodDeclaration mem | mem.getBody() = this)
    else
      if this instanceof @decorator_list
      then result = "parameter decorators of " + this.(ASTNode).getParent().(Function).describe()
      else result = toString()
  }
}

/**
 * A synthetic CFG node that does not correspond to a statement or expression;
 * examples include guard nodes and entry/exit nodes.
 */
class SyntheticControlFlowNode extends @synthetic_cfg_node, ControlFlowNode {
  override Location getLocation() { hasLocation(this, result) }
}

/** A synthetic CFG node marking the entry point of a function or toplevel script. */
class ControlFlowEntryNode extends SyntheticControlFlowNode, @entry_node {
  override predicate isUnreachable() { none() }

  override string toString() { result = "entry node of " + getContainer().toString() }
}

/** A synthetic CFG node marking the exit of a function or toplevel script. */
class ControlFlowExitNode extends SyntheticControlFlowNode, @exit_node {
  override predicate isAFinalNodeOfContainer(StmtContainer container) {
    exit_cfg_node(this, container)
  }

  override string toString() { result = "exit node of " + getContainer().toString() }
}

/**
 * A synthetic CFG node recording that some condition is known to hold
 * at this point in the program.
 */
class GuardControlFlowNode extends SyntheticControlFlowNode, @guard_node {
  /** Gets the expression that this guard concerns. */
  Expr getTest() { guard_node(this, _, result) }

  /**
   * Holds if this guard dominates basic block `bb`, that is, the guard
   * is known to hold at `bb`.
   */
  predicate dominates(ReachableBasicBlock bb) {
    this = bb.getANode()
    or
    exists(ReachableBasicBlock prev | prev.strictlyDominates(bb) | this = prev.getANode())
  }
}

/**
 * A guard node recording that some condition is known to be truthy or
 * falsy at this point in the program.
 */
class ConditionGuardNode extends GuardControlFlowNode, @condition_guard {
  /** Gets the value recorded for the condition. */
  boolean getOutcome() {
    guard_node(this, 0, _) and result = false
    or
    guard_node(this, 1, _) and result = true
  }

  override string toString() { result = "guard: " + getTest() + " is " + getOutcome() }
}

/**
 * A CFG node corresponding to a program element, that is, a CFG node that is
 * not a `SyntheticControlFlowNode`.
 */
class ConcreteControlFlowNode extends ControlFlowNode {
  ConcreteControlFlowNode() { not this instanceof SyntheticControlFlowNode }
}
