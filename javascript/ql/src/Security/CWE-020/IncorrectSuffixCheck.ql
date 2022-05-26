/**
 * @name Incorrect suffix check
 * @description Using indexOf to implement endsWith functionality is error-prone if the -1 case is not explicitly handled.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id js/incorrect-suffix-check
 * @tags security
 *       correctness
 *       external/cwe/cwe-020
 */

import javascript

/**
 * A call to `indexOf` or `lastIndexOf`.
 */
class IndexOfCall extends DataFlow::MethodCallNode {
  IndexOfCall() {
    exists(string name | name = this.getMethodName() |
      name = "indexOf" or
      name = "lastIndexOf"
    ) and
    this.getNumArgument() = 1
  }

  /** Gets the receiver or argument of this call. */
  DataFlow::Node getAnOperand() {
    result = this.getReceiver() or
    result = this.getArgument(0)
  }

  /**
   * Holds if `recv` is the local source of the receiver of this call, and `m`
   * is the name of the invoked method.
   */
  private predicate receiverAndMethodName(DataFlow::Node recv, string m) {
    this.getReceiver().getALocalSource() = recv and
    this.getMethodName() = m
  }

  /**
   * Gets an `indexOf` call with the same receiver, argument, and method name, including this call itself.
   */
  IndexOfCall getAnEquivalentIndexOfCall() {
    exists(DataFlow::Node recv, string m |
      this.receiverAndMethodName(recv, m) and result.receiverAndMethodName(recv, m)
    |
      result.getArgument(0).getALocalSource() = this.getArgument(0).getALocalSource()
      or
      result.getArgument(0).getStringValue() = this.getArgument(0).getStringValue()
    )
  }

  /**
   * Gets an expression that refers to the return value of this call.
   */
  Expr getAUse() { this.flowsToExpr(result) }
}

/**
 * Gets a source of the given string value, or one of its operands if it is a concatenation.
 */
DataFlow::SourceNode getStringSource(DataFlow::Node node) {
  result = node.getALocalSource()
  or
  result = StringConcatenation::getAnOperand(node).getALocalSource()
}

/**
 * An expression that takes the length of a string literal.
 */
class LiteralLengthExpr extends DotExpr {
  LiteralLengthExpr() {
    this.getPropertyName() = "length" and
    this.getBase() instanceof StringLiteral
  }

  /**
   * Gets the value of the string literal whose length is taken.
   */
  string getBaseValue() { result = this.getBase().getStringValue() }
}

/**
 * Holds if `length` is derived from the length of the given `indexOf`-operand.
 */
predicate isDerivedFromLength(DataFlow::Node length, DataFlow::Node operand) {
  exists(IndexOfCall call | operand = call.getAnOperand() |
    length = getStringSource(operand).getAPropertyRead("length")
    or
    exists(string val | val = operand.getStringValue() |
      // Find a literal length with the same string constant
      exists(LiteralLengthExpr lengthExpr |
        lengthExpr.getContainer() = call.getContainer() and
        lengthExpr.getBaseValue() = val and
        length = lengthExpr.flow()
      )
      or
      // Find an integer constant that equals the length of string constant
      exists(Expr lengthExpr |
        lengthExpr.getContainer() = call.getContainer() and
        lengthExpr.getIntValue() = val.length() and
        length = lengthExpr.flow()
      )
    )
  )
  or
  isDerivedFromLength(length.getAPredecessor(), operand)
  or
  exists(BinaryExpr expr | expr instanceof SubExpr or expr instanceof AddExpr |
    isDerivedFromLength(expr.getAnOperand().flow(), operand) and
    length = expr.flow()
  )
}

/**
 * An equality comparison of form `A.indexOf(B) === A.length - B.length` or similar.
 *
 * We assume A and B are strings, even A and/or B could be also be arrays.
 * The comparison with the length rarely occurs for arrays, however.
 */
class UnsafeIndexOfComparison extends EqualityTest {
  IndexOfCall indexOf;

  UnsafeIndexOfComparison() {
    exists(DataFlow::Node testedValue |
      this.hasOperands(indexOf.getAUse(), testedValue.asExpr()) and
      isDerivedFromLength(testedValue, indexOf.getReceiver()) and
      isDerivedFromLength(testedValue, indexOf.getArgument(0))
    ) and
    // Ignore cases like `x.indexOf("/") === x.length - 1` that can only be bypassed if `x` is the empty string.
    // Sometimes strings are just known to be non-empty from the context, and it is unlikely to be a security issue,
    // since it's obviously not a domain name check.
    not indexOf.getArgument(0).mayHaveStringValue(any(string s | s.length() = 1)) and
    // Relative string length comparison, such as A.length > B.length, or (A.length - B.length) > 0
    not exists(RelationalComparison compare |
      isDerivedFromLength(compare.getAnOperand().flow(), indexOf.getReceiver()) and
      isDerivedFromLength(compare.getAnOperand().flow(), indexOf.getArgument(0))
    ) and
    // Check for indexOf being -1
    not exists(EqualityTest test, Expr minusOne |
      test.hasOperands(indexOf.getAnEquivalentIndexOfCall().getAUse(), minusOne) and
      minusOne.getIntValue() = -1
    ) and
    // Check for indexOf being >1, or >=0, etc
    not exists(RelationalComparison test |
      test.getGreaterOperand() = indexOf.getAnEquivalentIndexOfCall().getAUse() and
      exists(int value | value = test.getLesserOperand().getIntValue() |
        value >= 0
        or
        not test.isInclusive() and
        value = -1
      )
    ) and
    // Check for indexOf being <0, or <=-1
    not exists(RelationalComparison test |
      test.getLesserOperand() = indexOf.getAnEquivalentIndexOfCall().getAUse() and
      exists(int value | value = test.getGreaterOperand().getIntValue() |
        value < 0
        or
        not test.isInclusive() and
        value = 0
      )
    )
  }

  IndexOfCall getIndexOf() { result = indexOf }
}

from UnsafeIndexOfComparison comparison
select comparison,
  "This suffix check is missing a length comparison to correctly handle " +
    comparison.getIndexOf().getMethodName() + " returning -1."
