/**
 * Provides classes for recognizing membership tests.
 */

import javascript

/**
 * An expression that is tested for membership of a collection.
 *
 * Additional candidates can be added by subclassing `MembershipCandidate::Range`
 */
class MembershipCandidate extends DataFlow::Node instanceof MembershipCandidate::Range {
  /**
   * Gets the expression that performs the membership test, if any.
   */
  DataFlow::Node getTest() { result = super.getTest() }

  /**
   * Gets a string that this candidate is tested against, if
   * it can be determined.
   */
  string getAMemberString() { result = super.getAMemberString() }

  /**
   * Gets a node that this candidate is tested against, if
   * it can be determined.
   */
  DataFlow::Node getAMemberNode() { result = super.getAMemberNode() }

  /**
   * Gets the polarity of the test.
   *
   * If the polarity is `false` the test returns `true` if the
   * collection does not contain this candidate.
   */
  boolean getTestPolarity() { result = super.getTestPolarity() }
}

/**
 * Provides classes for recognizing membership candidates.
 */
module MembershipCandidate {
  /**
   * An expression that is tested for membership of a collection.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Gets the expression that performs the membership test, if any.
     */
    abstract DataFlow::Node getTest();

    /**
     * Gets a string that this candidate is tested against, if
     * it can be determined.
     */
    string getAMemberString() { this.getAMemberNode().mayHaveStringValue(result) }

    /**
     * Gets a node that this candidate is tested against, if
     * it can be determined.
     */
    DataFlow::Node getAMemberNode() { none() }

    /**
     * Gets the polarity of the test.
     *
     * If the polarity is `false` the test returns `true` if the
     * collection does not contain this candidate.
     */
    boolean getTestPolarity() { result = true }
  }

  /**
   * An `InclusionTest` candidate viewed as a `MembershipCandidate`.
   */
  private class OrdinaryInclusionTestCandidate extends MembershipCandidate::Range {
    InclusionTest test;

    OrdinaryInclusionTestCandidate() { this = test.getContainedNode() }

    override DataFlow::Node getTest() { result = test }

    override boolean getTestPolarity() { result = test.getPolarity() }
  }

  /**
   * A candidate that may be a member of an array.
   */
  class ArrayMembershipCandidate extends OrdinaryInclusionTestCandidate {
    DataFlow::ArrayCreationNode array;

    ArrayMembershipCandidate() { array.flowsTo(test.getContainerNode()) }

    /**
     * Gets the array of this test.
     */
    DataFlow::ArrayCreationNode getArray() { result = array }

    override DataFlow::Node getAMemberNode() { result = array.getAnElement() }
  }

  /**
   * A candidate that may be a member of an array constructed
   * from a call to `String.prototype.split`.
   */
  private class ShorthandArrayMembershipCandidate extends OrdinaryInclusionTestCandidate {
    string toSplit;
    string separator;

    ShorthandArrayMembershipCandidate() {
      exists(StringSplitCall split |
        split.flowsTo(test.getContainerNode()) and
        toSplit = split.getBaseString().getStringValue() and
        separator = split.getSeparator()
      )
    }

    override string getAMemberString() { result = toSplit.splitAt(separator) }
  }

  /**
   * An `EqualityTest` operand viewed as a `MembershipCandidate`.
   */
  private class EqualityTestOperand extends MembershipCandidate::Range, DataFlow::ValueNode {
    EqualityTest test;

    EqualityTestOperand() { this = test.getAnOperand().flow() }

    override DataFlow::Node getTest() { result = test.flow() }

    override DataFlow::Node getAMemberNode() { test.hasOperands(this.asExpr(), result.asExpr()) }

    override boolean getTestPolarity() { result = test.getPolarity() }
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
   * A candidate that may be matched by a regular expression that
   * enumerates all of its matched strings.
   */
  private class RegExpEnumerationCandidate extends MembershipCandidate::Range, DataFlow::Node {
    DataFlow::Node test;
    EnumerationRegExp enumeration;
    boolean polarity;

    pragma[nomagic]
    RegExpEnumerationCandidate() {
      exists(DataFlow::MethodCallNode mcn, DataFlow::Node base, string m, DataFlow::Node firstArg |
        (
          test = any(ConditionGuardNode g).getTest().flow() and
          mcn.flowsTo(test) and
          polarity = true
          or
          exists(EqualityTest eq, Expr null, Expr op |
            test = eq.flow() and
            polarity = eq.getPolarity().booleanNot() and
            mcn.flowsToExpr(op) and
            eq.hasOperands(op, null) and
            SyntacticConstants::isNull(null)
          )
        ) and
        mcn.calls(base, m) and
        firstArg = mcn.getArgument(0)
      |
        // /re/.test(u) or /re/.exec(u)
        enumeration = RegExp::getRegExpObjectFromNode(base) and
        (m = "test" or m = "exec") and
        firstArg = this
        or
        // u.match(/re/) or u.match("re")
        base = this and
        m = "match" and
        enumeration = RegExp::getRegExpFromNode(firstArg)
      )
    }

    override DataFlow::Node getTest() { result = test }

    override string getAMemberString() { result = enumeration.getAMember() }

    override boolean getTestPolarity() { result = polarity }
  }

  /**
   * A candidate that may be a member of a collection class, such as a map or set.
   */
  class CollectionMembershipCandidate extends MembershipCandidate::Range {
    DataFlow::MethodCallNode test;

    CollectionMembershipCandidate() { test.getMethodName() = "has" and this = test.getArgument(0) }

    override DataFlow::Node getTest() { result = test }
  }

  /**
   * A candidate that may be a property name of an object.
   */
  class ObjectPropertyNameMembershipCandidate extends MembershipCandidate::Range,
    DataFlow::ValueNode {
    Expr test;
    Expr membersNode;

    ObjectPropertyNameMembershipCandidate() {
      exists(InExpr inExpr |
        this = inExpr.getLeftOperand().flow() and
        test = inExpr and
        membersNode = inExpr.getRightOperand()
      )
      or
      exists(MethodCallExpr hasOwn |
        this = hasOwn.getArgument(0).flow() and
        test = hasOwn and
        hasOwn.calls(membersNode, "hasOwnProperty")
      )
    }

    override DataFlow::Node getTest() { result = test.flow() }

    override string getAMemberString() {
      exists(membersNode.flow().getALocalSource().getAPropertyWrite(result))
    }
  }

  /**
   * A candidate that may match a switch case.
   */
  class SwitchCaseCandidate extends MembershipCandidate::Range {
    SwitchStmt switch;

    SwitchCaseCandidate() { this = switch.getExpr().flow() }

    override DataFlow::Node getTest() { none() }

    override DataFlow::Node getAMemberNode() { result = switch.getACase().getExpr().flow() }
  }
}
