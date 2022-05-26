/**
 * Provides classes and predicates for reasoning about string-manipulating expressions.
 */

private import ruby
private import codeql.ruby.DataFlow
private import codeql.ruby.controlflow.CfgNodes
private import InclusionTests

/**
 * Provides classes for reasoning about string-manipulating expressions.
 */
module StringOps {
  /**
   * A expression that is equivalent to `A.start_with?(B)` or `!A.start_with?(B)`.
   */
  class StartsWith extends DataFlow::Node instanceof StartsWith::Range {
    /**
     * Gets the `A` in `A.start_with?(B)`.
     */
    final DataFlow::Node getBaseString() { result = super.getBaseString() }

    /**
     * Gets the `B` in `A.start_with?(B)`.
     */
    final DataFlow::Node getSubstring() { result = super.getSubstring() }

    /**
     * Gets the polarity of the check.
     *
     * If the polarity is `false` the check returns `true` if the string does not start
     * with the given substring.
     */
    final boolean getPolarity() { result = super.getPolarity() }
  }

  /**
   * Provides classes implementing prefix test expressions.
   */
  module StartsWith {
    /**
     * A expression that is equivalent to `A.start_with?(B)` or `!A.start_with?(B)`.
     */
    abstract class Range extends DataFlow::Node {
      /**
       * Gets the `A` in `A.start_with?(B)`.
       */
      abstract DataFlow::Node getBaseString();

      /**
       * Gets the `B` in `A.start_with?(B)`.
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
     * An expression of form `A.start_with?(B)`.
     */
    private class StartsWith_Native extends Range, DataFlow::CallNode {
      StartsWith_Native() { this.getMethodName() = "start_with?" }

      override DataFlow::Node getBaseString() { result = this.getReceiver() }

      override DataFlow::Node getSubstring() { result = this.getArgument(_) }
    }

    /**
     * An expression of form `A.index(B) == 0` or `A.index(B) != 0`.
     */
    private class StartsWith_IndexOfEquals extends Range {
      private DataFlow::CallNode indexOf;
      private boolean polarity;

      StartsWith_IndexOfEquals() {
        exists(ExprNodes::ComparisonOperationCfgNode comparison |
          this.asExpr() = comparison and
          indexOf.getMethodName() = "index" and
          strictcount(indexOf.getArgument(_)) = 1 and
          indexOf.flowsTo(any(DataFlow::Node n | n.asExpr() = comparison.getAnOperand())) and
          comparison.getAnOperand().getConstantValue().getInt() = 0
        |
          polarity = true and comparison.getExpr() instanceof EqExpr
          or
          polarity = true and comparison.getExpr() instanceof CaseEqExpr
          or
          polarity = false and comparison.getExpr() instanceof NEExpr
        )
      }

      override DataFlow::Node getBaseString() { result = indexOf.getReceiver() }

      override DataFlow::Node getSubstring() { result = indexOf.getArgument(0) }

      override boolean getPolarity() { result = polarity }
    }
  }

  /**
   * An expression that is equivalent to `A.include?(B)` or `!A.include?(B)`.
   * Note that this class is equivalent to `InclusionTest`, which also matches
   * inclusion tests on array objects.
   */
  class Includes extends InclusionTest {
    /** Gets the `A` in `A.include?(B)`. */
    final DataFlow::Node getBaseString() { result = super.getContainerNode() }

    /** Gets the `B` in `A.include?(B)`. */
    final DataFlow::Node getSubstring() { result = super.getContainedNode() }
  }

  /**
   * An expression that is equivalent to `A.end_with?(B)` or `!A.end_with?(B)`.
   */
  class EndsWith extends DataFlow::Node instanceof EndsWith::Range {
    /**
     * Gets the `A` in `A.start_with?(B)`.
     */
    final DataFlow::Node getBaseString() { result = super.getBaseString() }

    /**
     * Gets the `B` in `A.start_with?(B)`.
     */
    final DataFlow::Node getSubstring() { result = super.getSubstring() }

    /**
     * Gets the polarity if the check.
     *
     * If the polarity is `false` the check returns `true` if the string does not end
     * with the given substring.
     */
    final boolean getPolarity() { result = super.getPolarity() }
  }

  /**
   * Provides classes implementing suffix test expressions.
   */
  module EndsWith {
    /**
     * An expression that is equivalent to `A.end_with?(B)` or `!A.end_with?(B)`.
     */
    abstract class Range extends DataFlow::Node {
      /**
       * Gets the `A` in `A.end_with?(B)`.
       */
      abstract DataFlow::Node getBaseString();

      /**
       * Gets the `B` in `A.end_with?(B)`.
       */
      abstract DataFlow::Node getSubstring();

      /**
       * Gets the polarity if the check.
       *
       * If the polarity is `false` the check returns `true` if the string does not end
       * with the given substring.
       */
      boolean getPolarity() { result = true }
    }

    /**
     * An expression of form `A.end_with?(B)`.
     */
    private class EndsWith_Native extends Range, DataFlow::CallNode {
      EndsWith_Native() { this.getMethodName() = "end_with?" }

      override DataFlow::Node getBaseString() { result = this.getReceiver() }

      override DataFlow::Node getSubstring() { result = this.getArgument(_) }
    }
  }
}
