/**
 * Provides predicates for analyzing string concatenations and their operands.
 */

import ruby
import codeql.ruby.AST

/**
 * Provides predicates for analyzing string concatenations and their operands.
 */
module StringConcatenation {
  private newtype TOperand =
    TDataFlowNode(DataFlow::Node n) or
    TStringComponent(StringComponent c)

  /**
   * A potential operand to a string concatenation operation.
   */
  class Operand extends TOperand {
    /** Gets this operand as a `DataFlow::Node`, if applicable. */
    DataFlow::Node asDataFlowNode() { this = TDataFlowNode(result) }

    /** Gets this operand as a `StringComponent`, if applicable. */
    StringComponent asStringComponent() { this = TStringComponent(result) }

    /** Gets the constant value of this operand, if any. */
    ConstantValue getConstantValue() {
      result = this.asDataFlowNode().getConstantValue()
      or
      result = this.asStringComponent().getConstantValue()
    }

    /** Gets a string representation of this operand. */
    string toString() {
      result = this.asDataFlowNode().toString()
      or
      result = this.asStringComponent().toString()
    }
  }

  pragma[nomagic]
  private DataFlow::Node getDataFlowOperand(DataFlow::Node node, int n) {
    exists(DataFlow::BinaryOperationNode binop, AddExpr add |
      binop.asOperationAstNode() = add and binop = node
    |
      n = 0 and result = binop.getLeftOperand()
      or
      n = 1 and result = binop.getRightOperand()
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

  private StringComponent getStringComponentOperand(DataFlow::Node node, int n) {
    result = node.asExpr().getExpr().(StringlikeLiteral).getComponent(n)
  }

  /** Gets the `n`th operand to the string concatenation defining `node`. */
  Operand getOperand(DataFlow::Node node, int n) {
    result = TDataFlowNode(getDataFlowOperand(node, n)) or
    result = TStringComponent(getStringComponentOperand(node, n))
  }

  /** Gets an operand to the string concatenation defining `node`. */
  Operand getAnOperand(DataFlow::Node node) { result = getOperand(node, _) }

  /** Gets the number of operands to the given concatenation. */
  int getNumOperand(DataFlow::Node node) { result = strictcount(getAnOperand(node)) }

  /** Gets the first operand to the string concatenation defining `node`. */
  Operand getFirstOperand(DataFlow::Node node) { result = getOperand(node, 0) }

  /** Gets the last operand to the string concatenation defining `node`. */
  Operand getLastOperand(DataFlow::Node node) { result = getOperand(node, getNumOperand(node) - 1) }

  /**
   * Holds if `src` flows to `dst` through the `n`th operand of the given concatenation operator.
   */
  predicate taintStep(DataFlow::Node src, DataFlow::Node dst, DataFlow::Node operator, int n) {
    src = getOperand(dst, n).asDataFlowNode() and
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
    not node = getAnOperand(_).asDataFlowNode()
  }

  /**
   * Gets the root of the concatenation tree in which `node` is an operand or operator.
   */
  DataFlow::Node getRoot(DataFlow::Node node) {
    isRoot(node) and
    result = node
    or
    exists(DataFlow::Node operator |
      node = getAnOperand(operator).asDataFlowNode() and
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
