/**
 * Provides classes for recognizing membership tests.
 */

import javascript

/**
 * An expression that tests if a candidate is a member of a collection.
 *
 * Additional tests can be added by subclassing `MembershipTest::Range`
 */
class MembershipTest extends DataFlow::Node {
  MembershipTest::Range range;

  MembershipTest() { this = range }

  /**
   * Gets the candidate of this test.
   */
  DataFlow::Node tests() { result = range.tests() }

  /**
   * Gets a string that is a member of the collection of this test, if
   * it can be determined.
   */
  string getAMemberString() { result = range.getAMemberString() }

  /**
   * Gets a node that is a member of the collection of this test, if
   * it can be determined.
   */
  DataFlow::Node getAMemberNode() { result = range.getAMemberNode() }

  /**
   * Gets the polarity of this test.
   *
   * If the polarity is `false` the test returns `true` if the
   * collection does not contain the candidate.
   */
  boolean getPolarity() { result = range.getPolarity() }
}

/**
 * Provides classes for recognizing membership tests.
 */
module MembershipTest {
  /**
   * An expression that tests if a candidate is a member of a collection.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets the candidate of this test.
     */
    abstract DataFlow::Node tests();

    /**
     * Gets a string that is a member of the collection of this test, if
     * it can be determined.
     */
    string getAMemberString() { this.getAMemberNode().mayHaveStringValue(result) }

    /**
     * Gets a node that is a member of the collection of this test, if
     * it can be determined.
     */
    DataFlow::Node getAMemberNode() { none() }

    /**
     * Gets the polarity of this test.
     *
     * If the polarity is `false` the test returns `true` if the
     * collection does not contain the candidate.
     */
    boolean getPolarity() { result = true }
  }

  /**
   * An `InclusionTest` viewed as a `MembershipTest`.
   */
  private class OrdinaryInclusionTest extends InclusionTest, MembershipTest::Range {
    override DataFlow::Node tests() { result = this.getContainedNode() }

    override boolean getPolarity() { result = InclusionTest.super.getPolarity() }
  }

  /**
   * A test for whether a candidate is a member of an array.
   */
  class ArrayMembershipTest extends OrdinaryInclusionTest {
    DataFlow::ArrayCreationNode array;

    ArrayMembershipTest() { array.flowsTo(this.getContainerNode()) }

    /**
     * Gets the array of this test.
     */
    DataFlow::ArrayCreationNode getArray() { result = array }

    override DataFlow::Node getAMemberNode() { result = array.getAnElement() }
  }

  /**
   * A test for whether a candidate is a member of an array constructed
   * from a call to `String.prototype.split`.
   */
  private class ShorthandArrayMembershipTest extends OrdinaryInclusionTest {
    DataFlow::MethodCallNode split;

    ShorthandArrayMembershipTest() {
      split.getMethodName() = "split" and
      split.getNumArgument() = [1, 2] and
      split.flowsTo(this.getContainerNode())
    }

    override string getAMemberString() {
      exists(string toSplit |
        split.getReceiver().getStringValue() = toSplit and
        result = toSplit.splitAt(split.getArgument(0).getStringValue())
      )
    }
  }

  /**
   * An `EqualityTest` viewed as a `MembershipTest`.
   */
  private class EqualityLeftMembershipTest extends MembershipTest::Range, DataFlow::ValueNode {
    override EqualityTest astNode;

    override DataFlow::Node tests() { astNode.getLeftOperand() = result.asExpr() }

    override DataFlow::Node getAMemberNode() { result = astNode.getRightOperand().flow() }

    override boolean getPolarity() { result = astNode.getPolarity() }
  }

  /**
   * An `EqualityTest` viewed as a `MembershipTest`.
   */
  private class EqualityRightMembershipTest extends MembershipTest::Range, DataFlow::ValueNode {
    override EqualityTest astNode;

    override DataFlow::Node tests() { astNode.getRightOperand() = result.asExpr() }

    override DataFlow::Node getAMemberNode() { result = astNode.getLeftOperand().flow() }

    override boolean getPolarity() { result = astNode.getPolarity() }
  }

  /**
   * A regular expression that enumerates all of its matched strings.
   */
  private class EnumerationRegExp extends RegExpTerm {
    EnumerationRegExp() {
      this.isRootTerm() and
      RegExp::isFullyAnchoredTerm(this) and
      exists(RegExpTerm child | this.getAChild*() = child |
        child instanceof RegExpSequence or
        child instanceof RegExpCaret or
        child instanceof RegExpDollar or
        child instanceof RegExpConstant or
        child instanceof RegExpAlt or
        child instanceof RegExpGroup
      )
    }

    /**
     * Gets a string matched by this regular expression.
     */
    string getAMember() { result = this.getAChild*().getAMatchedString() }
  }

  /**
   * A test for whether a string is matched by a regular expression that
   * enumerates all of its matched strings.
   */
  private class RegExpEnumerationTest extends MembershipTest::Range, DataFlow::Node {
    EnumerationRegExp enumeration;
    DataFlow::Node candidateNode;
    boolean polarity;

    RegExpEnumerationTest() {
      exists(
        DataFlow::Node tests, DataFlow::MethodCallNode mcn, DataFlow::Node base, string m,
        DataFlow::Node firstArg
      |
        (
          this = tests and
          any(ConditionGuardNode g).getTest() = tests.asExpr() and
          polarity = true
          or
          exists(EqualityTest eq, Expr null |
            eq.flow() = this and
            polarity = eq.getPolarity().booleanNot() and
            eq.hasOperands(tests.asExpr(), null) and
            SyntacticConstants::isNull(null)
          )
        ) and
        mcn.flowsTo(tests) and
        mcn.calls(base, m) and
        firstArg = mcn.getArgument(0)
      |
        // /re/.test(u) or /re/.exec(u)
        enumeration = RegExp::getRegExpObjectFromNode(base) and
        (m = "test" or m = "exec") and
        firstArg = candidateNode
        or
        // u.match(/re/) or u.match("re")
        base = candidateNode and
        m = "match" and
        enumeration = RegExp::getRegExpFromNode(firstArg)
      )
    }

    override DataFlow::Node tests() { result = candidateNode }

    override string getAMemberString() { result = enumeration.getAMember() }

    override boolean getPolarity() { result = polarity }
  }

  /**
   * An expression that tests if a candidate is a member of a collection class, such as a map or set.
   */
  class CollectionMembershipTest extends MembershipTest::Range, DataFlow::MethodCallNode {
    CollectionMembershipTest() { getMethodName() = "has" }

    override DataFlow::Node tests() { result = getArgument(0) }
  }

  /**
   * An expression that tests if a candidate is a property name of an object.
   */
  class ObjectPropertyNameMembershipTest extends MembershipTest::Range, DataFlow::ValueNode {
    DataFlow::ValueNode candidateNode;
    DataFlow::ValueNode membersNode;

    ObjectPropertyNameMembershipTest() {
      exists(InExpr inExpr |
        astNode = inExpr and
        inExpr.getLeftOperand() = candidateNode.asExpr() and
        inExpr.getRightOperand() = membersNode.asExpr()
      )
      or
      exists(DataFlow::MethodCallNode hasOwn |
        this = hasOwn and
        hasOwn.calls(membersNode, "hasOwnProperty") and
        hasOwn.getArgument(0) = candidateNode
      )
    }

    override DataFlow::Node tests() { result = candidateNode }

    override string getAMemberString() {
      exists(membersNode.getALocalSource().getAPropertyWrite(result))
    }
  }
}
