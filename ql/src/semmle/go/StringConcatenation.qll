/**
 * Provides predicates for analyzing string concatenations and their operands.
 */

import go

module StringConcatenation {
  /** Gets the `n`th operand to the string concatenation defining `node`. */
  DataFlow::Node getOperand(DataFlow::Node node, int n) {
    node.getType() instanceof StringType and
    exists(DataFlow::BinaryOperationNode add | add = node and add.getOperator() = "+" |
      n = 0 and result = add.getLeftOperand()
      or
      n = 1 and result = add.getRightOperand()
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
  DataFlow::Node getRoot(DataFlow::Node node) { isRoot(result) and node = getAnOperand*(result) }
}
