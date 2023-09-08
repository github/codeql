/**
 * Provides predicates for analyzing string concatenations and their operands.
 */

import ruby
import codeql.ruby.AST

/**
 * Provides predicates for analyzing string concatenations and their operands.
 */
module StringConcatenation {
  /** Gets a data flow node referring to the result of the given concatenation. */
  private DataFlow::Node getAssignAddResult(AssignAddExpr expr) {
    result.asExpr().getExpr() = expr
    or
    result.asExpr().getExpr() = expr.getLeftOperand()
  }

  /** Gets the `n`th operand to the string concatenation defining `node`. */
  pragma[nomagic]
  DataFlow::Node getOperand(DataFlow::Node node, int n) {
    exists(AddExpr add | node.asExpr().getExpr() = add |
      n = 0 and result.asExpr().getExpr() = add.getLeftOperand()
      or
      n = 1 and result.asExpr().getExpr() = add.getRightOperand()
    )
    or
    exists(StringlikeLiteral str | node.asExpr().getExpr() = str |
      result.asExpr().getExpr() = str.getComponent(n)
    )
    or
    exists(AssignAddExpr assign | node = getAssignAddResult(assign) |
      n = 0 and result.asExpr().getExpr() = assign.getLeftOperand()
      or
      n = 1 and result.asExpr().getExpr() = assign.getRightOperand()
    )
    or
    exists(DataFlow::ArrayLiteralNode array, DataFlow::CallNode call |
      call = array.getAMethodCall("join") and
      (
        call.getArgument(0).getConstantValue().isStringlikeValue("") or
        call.getNumberOfArguments() = 0
      ) and
      (
        // step from array element to array
        result = array.getElement(n) and
        node = array
        or
        // step from array to join call
        node = call and
        result = array and
        n = 0
      )
    )
    or
    exists(DataFlow::CallNode call |
      node = call and
      call.getMethodName() = "concat" and
      not exists(DataFlow::ArrayLiteralNode array |
        array.flowsTo(call.getArgument(_)) or array.flowsTo(call.getReceiver())
      ) and
      (
        n = 0 and
        result = call.getReceiver()
        or
        result = call.getArgument(n - 1)
      )
    )
  }

  /** Gets an operand to the string concatenation defining `node`. */
  DataFlow::Node getAnOperand(DataFlow::Node node) { result = getOperand(node, _) }

  /** Gets the number of operands to the given concatenation. */
  int getNumOperand(DataFlow::Node node) { result = strictcount(getAnOperand(node)) }

  /** Gets the first operand to the string concatenation defining `node`. */
  DataFlow::Node getFirstOperand(DataFlow::Node node) { result = getOperand(node, 0) }

  /** Gets the last operand to the string concatenation defining `node`. */
  DataFlow::Node getLastOperand(DataFlow::Node node) {
    result = getOperand(node, getNumOperand(node) - 1)
  }

  /**
   * Holds if `src` flows to `dst` through the `n`th operand of the given concatenation operator.
   */
  predicate taintStep(DataFlow::Node src, DataFlow::Node dst, DataFlow::Node operator, int n) {
    src = getOperand(dst, n) and
    operator = dst
  }

  /**
   * Holds if there is a taint step from `src` to `dst` through string concatenation.
   */
  predicate taintStep(DataFlow::Node src, DataFlow::Node dst) { taintStep(src, dst, _, _) }

  /**
   * Holds if `node` is the root of a concatenation tree, that is,
   * it is a concatenation operator that is not itself the immediate operand to
   * another concatenation operator.
   */
  predicate isRoot(DataFlow::Node node) {
    exists(getAnOperand(node)) and
    not node = getAnOperand(_)
  }

  /**
   * Gets the root of the concatenation tree in which `node` is an operand or operator.
   */
  DataFlow::Node getRoot(DataFlow::Node node) {
    isRoot(node) and
    result = node
    or
    exists(DataFlow::Node operator |
      node = getAnOperand(operator) and
      result = getRoot(operator)
    )
  }

  /**
   * Holds if `node` is a string concatenation that only acts as a string coercion.
   */
  predicate isCoercion(DataFlow::Node node) {
    getNumOperand(node) = 2 and
    getOperand(node, _).getConstantValue().isStringlikeValue("")
  }
}
