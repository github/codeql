/**
 * Contains classes for recognizing array and string inclusion tests.
 */

private import javascript

/**
 * An expression that checks if an element is contained in an array
 * or is a substring of another string.
 *
 * Examples:
 * ```
 * A.includes(B)
 * A.indexOf(B) !== -1
 * A.indexOf(B) >= 0
 * ~A.indexOf(B)
 * ```
 */
class InclusionTest extends DataFlow::Node {
  InclusionTest::Range range;

  InclusionTest() { this = range }

  /** Gets the `A` in `A.includes(B)`. */
  DataFlow::Node getContainerNode() { result = range.getContainerNode() }

  /** Gets the `B` in `A.includes(B)`. */
  DataFlow::Node getContainedNode() { result = range.getContainedNode() }

  /**
   * Gets the polarity of the check.
   *
   * If the polarity is `false` the check returns `true` if the container does not contain
   * the given element.
   */
  boolean getPolarity() { result = range.getPolarity() }
}

module InclusionTest {
  /**
   * A expression that is equivalent to `A.includes(B)` or `!A.includes(B)`.
   *
   * Note that this also includes calls to the array method named `includes`.
   */
  abstract class Range extends DataFlow::Node {
    /** Gets the `A` in `A.includes(B)`. */
    abstract DataFlow::Node getContainerNode();

    /** Gets the `B` in `A.includes(B)`. */
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
   * A call to a utility function (`callee`) that performs an InclusionTest (`inner`).
   */
  private class IndirectInclusionTest extends Range, DataFlow::CallNode {
    InclusionTest inner;
    Function callee;

    IndirectInclusionTest() {
      inner.getEnclosingExpr() = unique(Expr ret | ret = callee.getAReturnedExpr()) and
      callee = unique(Function f | f = this.getACallee()) and
      not this.isImprecise() and
      inner.getContainedNode().getALocalSource() = DataFlow::parameterNode(callee.getAParameter()) and
      inner.getContainerNode().getALocalSource() = DataFlow::parameterNode(callee.getAParameter())
    }

    override DataFlow::Node getContainerNode() {
      exists(int arg |
        inner.getContainerNode().getALocalSource() =
          DataFlow::parameterNode(callee.getParameter(arg)) and
        result = this.getArgument(arg)
      )
    }

    override DataFlow::Node getContainedNode() {
      exists(int arg |
        inner.getContainedNode().getALocalSource() =
          DataFlow::parameterNode(callee.getParameter(arg)) and
        result = this.getArgument(arg)
      )
    }

    override boolean getPolarity() { result = inner.getPolarity() }
  }

  /**
   * A call to a method named `includes`, assumed to refer to `String.prototype.includes`
   * or `Array.prototype.includes`.
   */
  private class Includes_Native extends Range, DataFlow::MethodCallNode {
    Includes_Native() {
      getMethodName() = "includes" and
      getNumArgument() = 1
    }

    override DataFlow::Node getContainerNode() { result = getReceiver() }

    override DataFlow::Node getContainedNode() { result = getArgument(0) }
  }

  /**
   * A call to `_.includes` or similar, assumed to operate on strings.
   */
  private class Includes_Library extends Range, DataFlow::CallNode {
    Includes_Library() {
      exists(string name |
        this = LodashUnderscore::member(name).getACall() and
        (name = "includes" or name = "include" or name = "contains")
        or
        this = Closure::moduleImport("goog.string." + name).getACall() and
        (name = "contains" or name = "caseInsensitiveContains")
      )
    }

    override DataFlow::Node getContainerNode() { result = getArgument(0) }

    override DataFlow::Node getContainedNode() { result = getArgument(1) }
  }

  /**
   * A check of form `A.indexOf(B) !== -1` or similar.
   */
  private class Includes_IndexOfEquals extends Range, DataFlow::ValueNode {
    MethodCallExpr indexOf;
    override EqualityTest astNode;

    Includes_IndexOfEquals() {
      exists(Expr index | astNode.hasOperands(indexOf, index) |
        // one operand is of the form `whitelist.indexOf(x)`
        indexOf.getMethodName() = "indexOf" and
        // and the other one is -1
        index.getIntValue() = -1
      )
    }

    override DataFlow::Node getContainerNode() { result = indexOf.getReceiver().flow() }

    override DataFlow::Node getContainedNode() { result = indexOf.getArgument(0).flow() }

    override boolean getPolarity() { result = astNode.getPolarity().booleanNot() }
  }

  /**
   * A check of form `A.indexOf(B) >= 0` or similar.
   */
  private class Includes_IndexOfRelational extends Range, DataFlow::ValueNode {
    MethodCallExpr indexOf;
    override RelationalComparison astNode;
    boolean polarity;

    Includes_IndexOfRelational() {
      exists(Expr lesser, Expr greater |
        astNode.getLesserOperand() = lesser and
        astNode.getGreaterOperand() = greater and
        indexOf.getMethodName() = "indexOf" and
        indexOf.getNumArgument() = 1
      |
        polarity = true and
        greater = indexOf and
        (
          lesser.getIntValue() = 0 and astNode.isInclusive()
          or
          lesser.getIntValue() = -1 and not astNode.isInclusive()
        )
        or
        polarity = false and
        lesser = indexOf and
        (
          greater.getIntValue() = -1 and astNode.isInclusive()
          or
          greater.getIntValue() = 0 and not astNode.isInclusive()
        )
      )
    }

    override DataFlow::Node getContainerNode() { result = indexOf.getReceiver().flow() }

    override DataFlow::Node getContainedNode() { result = indexOf.getArgument(0).flow() }

    override boolean getPolarity() { result = polarity }
  }

  /**
   * An expression of form `~A.indexOf(B)` which, when coerced to a boolean, is equivalent to `A.includes(B)`.
   */
  private class Includes_IndexOfBitwise extends Range, DataFlow::ValueNode {
    MethodCallExpr indexOf;
    override BitNotExpr astNode;

    Includes_IndexOfBitwise() {
      astNode.getOperand() = indexOf and
      indexOf.getMethodName() = "indexOf"
    }

    override DataFlow::Node getContainerNode() { result = indexOf.getReceiver().flow() }

    override DataFlow::Node getContainedNode() { result = indexOf.getArgument(0).flow() }
  }
}
