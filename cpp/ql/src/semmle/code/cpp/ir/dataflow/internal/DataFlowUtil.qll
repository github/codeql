/**
 * Provides C++-specific definitions for use in the data flow library.
 */

private import cpp
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.controlflow.IRGuards

/**
 * A node in a data flow graph.
 *
 * A node can be either an expression, a parameter, or an uninitialized local
 * variable. Such nodes are created with `DataFlow::exprNode`,
 * `DataFlow::parameterNode`, and `DataFlow::uninitializedNode` respectively.
 */
class Node extends Instruction {
  /**
   * INTERNAL: Do not use. Alternative name for `getFunction`.
   */
  Function getEnclosingCallable() { result = this.getEnclosingFunction() }

  /** Gets the type of this node. */
  Type getType() { result = this.getResultType() }

  /**
   * Gets the non-conversion expression corresponding to this node, if any. If
   * this node strictly (in the sense of `asConvertedExpr`) corresponds to a
   * `Conversion`, then the result is that `Conversion`'s non-`Conversion` base
   * expression.
   */
  Expr asExpr() {
    result.getConversion*() = this.getConvertedResultExpression() and
    not result instanceof Conversion
  }

  /**
   * Gets the expression corresponding to this node, if any. The returned
   * expression may be a `Conversion`.
   */
  Expr asConvertedExpr() { result = this.getConvertedResultExpression() }

  /** Gets the parameter corresponding to this node, if any. */
  Parameter asParameter() { result = this.(InitializeParameterInstruction).getParameter() }

  /**
   * Gets the uninitialized local variable corresponding to this node, if
   * any.
   */
  LocalVariable asUninitialized() { result = this.(UninitializedInstruction).getLocalVariable() }

  /**
   * Gets an upper bound on the type of this node.
   */
  Type getTypeBound() { result = getType() }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

/**
 * An expression, viewed as a node in a data flow graph.
 */
class ExprNode extends Node {
  ExprNode() { exists(this.asExpr()) }

  /**
   * Gets the non-conversion expression corresponding to this node, if any. If
   * this node strictly (in the sense of `getConvertedExpr`) corresponds to a
   * `Conversion`, then the result is that `Conversion`'s non-`Conversion` base
   * expression.
   */
  Expr getExpr() { result = this.asExpr() }

  /**
   * Gets the expression corresponding to this node, if any. The returned
   * expression may be a `Conversion`.
   */
  Expr getConvertedExpr() { result = this.asConvertedExpr() }
}

/**
 * The value of a parameter at function entry, viewed as a node in a data
 * flow graph.
 */
class ParameterNode extends Node, InitializeParameterInstruction {
  /**
   * Holds if this node is the parameter of `c` at the specified (zero-based)
   * position. The implicit `this` parameter is considered to have index `-1`.
   */
  predicate isParameterOf(Function f, int i) { f.getParameter(i) = getParameter() }
}

/**
 * The value of an uninitialized local variable, viewed as a node in a data
 * flow graph.
 */
class UninitializedNode extends Node, UninitializedInstruction { }

/**
 * A node associated with an object after an operation that might have
 * changed its state.
 *
 * This can be either the argument to a callable after the callable returns
 * (which might have mutated the argument), or the qualifier of a field after
 * an update to the field.
 *
 * Nodes corresponding to AST elements, for example `ExprNode`, usually refer
 * to the value before the update with the exception of `ClassInstanceExpr`,
 * which represents the value after the constructor has run.
 *
 * This class exists to match the interface used by Java. There are currently no non-abstract
 * classes that extend it. When we implement field flow, we can revisit this.
 */
abstract class PostUpdateNode extends Node {
  /**
   * Gets the node before the state update.
   */
  abstract Node getPreUpdateNode();
}

/**
 * Gets a `Node` corresponding to `e` or any of its conversions. There is no
 * result if `e` is a `Conversion`.
 */
ExprNode exprNode(Expr e) { result.getExpr() = e }

/**
 * Gets the `Node` corresponding to `e`, if any. Here, `e` may be a
 * `Conversion`.
 */
ExprNode convertedExprNode(Expr e) { result.getExpr() = e }

/**
 * Gets the `Node` corresponding to the value of `p` at function entry.
 */
ParameterNode parameterNode(Parameter p) { result.getParameter() = p }

/**
 * Gets the `Node` corresponding to the value of an uninitialized local
 * variable `v`.
 */
UninitializedNode uninitializedNode(LocalVariable v) { result.getLocalVariable() = v }

/**
 * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local
 * (intra-procedural) step.
 */
predicate localFlowStep(Node nodeFrom, Node nodeTo) {
  simpleLocalFlowStep(nodeFrom, nodeTo)
}

/**
 * INTERNAL: do not use.
 *
 * This is the local flow predicate that's used as a building block in global
 * data flow. It may have less flow than the `localFlowStep` predicate.
 */
predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo) {
  nodeTo.(CopyInstruction).getSourceValue() = nodeFrom or
  nodeTo.(PhiInstruction).getAnOperand().getDef() = nodeFrom or
  // Treat all conversions as flow, even conversions between different numeric types.
  nodeTo.(ConvertInstruction).getUnary() = nodeFrom
}

/**
 * Holds if data flows from `source` to `sink` in zero or more local
 * (intra-procedural) steps.
 */
predicate localFlow(Node source, Node sink) { localFlowStep*(source, sink) }

/**
 * A guard that validates some expression.
 *
 * To use this in a configuration, extend the class and provide a
 * characteristic predicate precisely specifying the guard, and override
 * `checks` to specify what is being validated and in which branch.
 *
 * It is important that all extending classes in scope are disjoint.
 */
class BarrierGuard extends IRGuardCondition {
  /** NOT YET SUPPORTED. Holds if this guard validates `e` upon evaluating to `b`. */
  abstract deprecated predicate checks(Instruction e, boolean b);

  /** Gets a node guarded by this guard. */
  final Node getAGuardedNode() {
    none() // stub
  }
}
