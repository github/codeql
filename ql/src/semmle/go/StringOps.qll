/**
 * Provides predicates and classes for working with string operations.
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

module StringOps {
  /**
   * An expression that is equivalent to `strings.HasPrefix(A, B)` or `!strings.HasPrefix(A, B)`.
   *
   * Extends this class to refine existing API models. If you want to model new APIs,
   * extend `StringOps::HasPrefix::Range` instead.
   */
  class HasPrefix extends DataFlow::Node {
    HasPrefix::Range range;

    HasPrefix() { range = this }

    /**
     * Gets the `A` in `strings.HasPrefix(A, B)`.
     */
    DataFlow::Node getBaseString() { result = range.getBaseString() }

    /**
     * Gets the `B` in `strings.HasPrefix(A, B)`.
     */
    DataFlow::Node getSubstring() { result = range.getSubstring() }

    /**
     * Gets the polarity of the check.
     *
     * If the polarity is `false` the check returns `true` if the string does not start
     * with the given substring.
     */
    boolean getPolarity() { result = range.getPolarity() }
  }

  class StartsWith = HasPrefix;

  module HasPrefix {
    /**
     * An expression that is equivalent to `strings.HasPrefix(A, B)` or `!strings.HasPrefix(A, B)`.
     *
     * Extends this class to model new APIs. If you want to refine existing API models, extend
     * `StringOps::HasPrefix` instead.
     */
    abstract class Range extends DataFlow::Node {
      /**
       * Gets the `A` in `strings.HasPrefix(A, B)`.
       */
      abstract DataFlow::Node getBaseString();

      /**
       * Gets the `B` in `strings.HasPrefix(A, B)`.
       */
      abstract DataFlow::Node getSubstring();

      /**
       * Gets the polarity of the check.
       *
       * If the polarity is `false` the check returns `true` if the string does not start
       * with the given substring.
       */
      boolean getPolarity() { result = true }
    }

    /**
     * An expression of form `strings.HasPrefix(A, B)`.
     */
    private class StringsHasPrefix extends Range, DataFlow::CallNode {
      StringsHasPrefix() { getTarget().hasQualifiedName("strings", "HasPrefix") }

      override DataFlow::Node getBaseString() { result = getArgument(0) }

      override DataFlow::Node getSubstring() { result = getArgument(1) }
    }

    /**
     * An expression of form `strings.Index(A, B) === 0`.
     */
    private class HasPrefix_IndexOfEquals extends Range, DataFlow::EqualityTestNode {
      DataFlow::CallNode indexOf;

      HasPrefix_IndexOfEquals() {
        indexOf.getTarget().hasQualifiedName("strings", "Index") and
        getAnOperand() = globalValueNumber(indexOf).getANode() and
        getAnOperand().getIntValue() = 0
      }

      override DataFlow::Node getBaseString() { result = indexOf.getArgument(0) }

      override DataFlow::Node getSubstring() { result = indexOf.getArgument(1) }

      override boolean getPolarity() { result = expr.getPolarity() }
    }

    /**
     * A comparison of form `x[0] === 'k'` for some rune literal `k`.
     */
    private class HasPrefix_FirstCharacter extends Range, DataFlow::EqualityTestNode {
      DataFlow::ElementReadNode read;
      DataFlow::Node runeLiteral;

      HasPrefix_FirstCharacter() {
        read.getBase().getType().getUnderlyingType() instanceof StringType and
        read.getIndex().getIntValue() = 0 and
        eq(_, globalValueNumber(read).getANode(), runeLiteral)
      }

      override DataFlow::Node getBaseString() { result = read.getBase() }

      override DataFlow::Node getSubstring() { result = runeLiteral }

      override boolean getPolarity() { result = expr.getPolarity() }
    }

    /**
     * A comparison of form `x[:len(y)] === y`.
     */
    private class HasPrefix_Substring extends Range, DataFlow::EqualityTestNode {
      DataFlow::SliceNode slice;
      DataFlow::Node substring;

      HasPrefix_Substring() {
        eq(_, slice, substring) and
        slice.getLow().getIntValue() = 0 and
        (
          exists(DataFlow::CallNode len |
            len = Builtin::len().getACall() and
            len.getArgument(0) = globalValueNumber(substring).getANode() and
            slice.getHigh() = globalValueNumber(len).getANode()
          )
          or
          substring.getStringValue().length() = slice.getHigh().getIntValue()
        )
      }

      override DataFlow::Node getBaseString() { result = slice.getBase() }

      override DataFlow::Node getSubstring() { result = substring }

      override boolean getPolarity() { result = expr.getPolarity() }
    }
  }
}
