/**
 * Contains classes for recognizing array and string inclusion tests.
 */

private import ruby
private import codeql.ruby.DataFlow
private import codeql.ruby.controlflow.CfgNodes

/**
 * An expression that checks if an element is contained in an array
 * or is a substring of another string.
 *
 * Examples:
 * ```
 * A.include?(B)
 * A.index(B) != nil
 * A.index(B) >= 0
 * ```
 */
class InclusionTest extends DataFlow::Node instanceof InclusionTest::Range {
  /** Gets the `A` in `A.include?(B)`. */
  final DataFlow::Node getContainerNode() { result = super.getContainerNode() }

  /** Gets the `B` in `A.include?(B)`. */
  final DataFlow::Node getContainedNode() { result = super.getContainedNode() }

  /**
   * Gets the polarity of the check.
   *
   * If the polarity is `false` the check returns `true` if the container does not contain
   * the given element.
   */
  final boolean getPolarity() { result = super.getPolarity() }
}

/**
 * Contains classes for recognizing array and string inclusion tests.
 */
module InclusionTest {
  /**
   * An expression that is equivalent to `A.include?(B)` or `!A.include?(B)`.
   *
   * Note that this also includes calls to the array method named `include?`.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets the `A` in `A.include?(B)`. */
    abstract DataFlow::Node getContainerNode();

    /** Gets the `B` in `A.include?(B)`. */
    abstract DataFlow::Node getContainedNode();

    /**
     * Gets the polarity of the check.
     *
     * If the polarity is `false` the check returns `true` if the container does not contain
     * the given element.
     */
    boolean getPolarity() { result = true }
  }

  /**
   * A call to a method named `include?`, assumed to refer to `String.include?`
   * or `Array.include?`.
   */
  private class Includes_Native extends Range, DataFlow::CallNode {
    Includes_Native() {
      this.getMethodName() = "include?" and
      strictcount(this.getArgument(_)) = 1
    }

    override DataFlow::Node getContainerNode() { result = this.getReceiver() }

    override DataFlow::Node getContainedNode() { result = this.getArgument(0) }
  }

  /**
   * A check of form `A.index(B) != nil`, `A.index(B) >= 0`, or similar.
   */
  private class Includes_IndexOfComparison extends Range, DataFlow::Node {
    private DataFlow::CallNode indexOf;
    private boolean polarity;

    Includes_IndexOfComparison() {
      exists(ExprCfgNode index, ExprNodes::ComparisonOperationCfgNode comparison, int value |
        indexOf.asExpr() = comparison.getAnOperand() and
        index = comparison.getAnOperand() and
        this.asExpr() = comparison and
        // one operand is of the form `whitelist.index(x)`
        indexOf.getMethodName() = "index" and
        // and the other one is 0 or -1
        (
          value = index.getConstantValue().getInt() and value = 0
          or
          index.getConstantValue().isNil() and value = -1
        )
      |
        value = -1 and polarity = false and comparison.getExpr() instanceof CaseEqExpr
        or
        value = -1 and polarity = false and comparison.getExpr() instanceof EqExpr
        or
        value = -1 and polarity = true and comparison.getExpr() instanceof NEExpr
        or
        exists(RelationalOperation op | op = comparison.getExpr() |
          exists(Expr lesser, Expr greater |
            op.getLesserOperand() = lesser and
            op.getGreaterOperand() = greater
          |
            polarity = true and
            greater = indexOf.asExpr().getExpr() and
            (
              value = 0 and op.isInclusive()
              or
              value = -1 and not op.isInclusive()
            )
            or
            polarity = false and
            lesser = indexOf.asExpr().getExpr() and
            (
              value = -1 and op.isInclusive()
              or
              value = 0 and not op.isInclusive()
            )
          )
        )
      )
    }

    override DataFlow::Node getContainerNode() { result = indexOf.getReceiver() }

    override DataFlow::Node getContainedNode() { result = indexOf.getArgument(0) }

    override boolean getPolarity() { result = polarity }
  }
}
