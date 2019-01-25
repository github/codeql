/**
 * Provides classes and predicates for reasoning about string-manipulating expressions.
 */
import javascript

module StringOps {

  /**
   * A expression that is equivalent to `A.startsWith(B)` or `!A.startsWith(B)`.
   */
  abstract class StartsWith extends DataFlow::Node {
    /**
     * Gets the `A` in `A.startsWith(B)`.
     */
    abstract DataFlow::Node getBaseString();

    /**
     * Gets the `B` in `A.startsWith(B)`.
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
   * An expression of form `A.startsWith(B)`.
   */
  private class StartsWith_Native extends StartsWith, DataFlow::MethodCallNode {
    StartsWith_Native() {
      getMethodName() = "startsWith" and
      getNumArgument() = 1
    }

    override DataFlow::Node getBaseString() {
      result = getReceiver()
    }

    override DataFlow::Node getSubstring() {
      result = getArgument(0)
    }
  }

  /**
   * An expression of form `A.indexOf(B) === 0`.
   */
  private class StartsWith_IndexOfEquals extends StartsWith, DataFlow::ValueNode {
    override EqualityTest astNode;
    DataFlow::MethodCallNode indexOf;

    StartsWith_IndexOfEquals() {
      indexOf.getMethodName() = "indexOf" and
      indexOf.getNumArgument() = 1 and
      indexOf.flowsToExpr(astNode.getAnOperand()) and
      astNode.getAnOperand().getIntValue() = 0
    }

    override DataFlow::Node getBaseString() {
      result = indexOf.getReceiver()
    }

    override DataFlow::Node getSubstring() {
      result = indexOf.getArgument(0)
    }

    override boolean getPolarity() {
      result = astNode.getPolarity()
    }
  }

  /**
   * An expression of form `A.indexOf(B)` coerced to a boolean.
   *
   * This is equivalent to `!A.startsWith(B)` since all return values other than zero map to `true`.
   */
  private class StartsWith_IndexOfCoercion extends StartsWith, DataFlow::MethodCallNode {
    StartsWith_IndexOfCoercion() {
      getMethodName() = "indexOf" and
      getNumArgument() = 1 and
      this.flowsToExpr(any(ConditionGuardNode guard).getTest()) // check for boolean coercion
    }

    override DataFlow::Node getBaseString() {
      result = getReceiver()
    }

    override DataFlow::Node getSubstring() {
      result = getArgument(0)
    }

    override boolean getPolarity() {
      result = false
    }
  }

  /**
   * A call of form `_.startsWith(A, B)` or `ramda.startsWith(A, B)`.
   */
  private class StartsWith_Library extends StartsWith, DataFlow::CallNode {
    StartsWith_Library() {
      getNumArgument() = 2 and
      exists (DataFlow::SourceNode callee | this = callee.getACall() |
        callee = LodashUnderscore::member("startsWith") or
        callee = DataFlow::moduleMember("ramda", "startsWith")
      )
    }

    override DataFlow::Node getBaseString() {
      result = getArgument(0)
    }

    override DataFlow::Node getSubstring() {
      result = getArgument(1)
    }
  }

  /**
   * A comparison of form `x[0] === "k"` for some single-character constant `k`.
   */
  private class StartsWith_FirstCharacter extends StartsWith, DataFlow::ValueNode {
    override EqualityTest astNode;
    DataFlow::PropRead read;
    Expr constant;

    StartsWith_FirstCharacter() {
      read.flowsTo(astNode.getAnOperand().flow()) and
      read.getPropertyNameExpr().getIntValue() = 0 and
      constant.getStringValue().length() = 1 and
      astNode.getAnOperand() = constant
    }

    override DataFlow::Node getBaseString() {
      result = read.getBase()
    }

    override DataFlow::Node getSubstring() {
      result = constant.flow()
    }

    override boolean getPolarity() {
      result = astNode.getPolarity()
    }
  }

  /**
   * A comparison of form `x.substring(0, y.length) === y`.
   */
  private class StartsWith_Substring extends StartsWith, DataFlow::ValueNode {
    override EqualityTest astNode;
    DataFlow::MethodCallNode call;
    DataFlow::Node substring;

    StartsWith_Substring() {
      astNode.hasOperands(call.asExpr(), substring.asExpr()) and
      (call.getMethodName() = "substring" or call.getMethodName() = "substr") and
      call.getNumArgument() = 2 and
      (
        substring.getALocalSource().getAPropertyRead("length").flowsTo(call.getArgument(1))
        or
        substring.asExpr().getStringValue().length() = call.getArgument(1).asExpr().getIntValue()
      )
    }

    override DataFlow::Node getBaseString() {
      result = call.getReceiver()
    }

    override DataFlow::Node getSubstring() {
      result = substring
    }

    override boolean getPolarity() {
      result = astNode.getPolarity()
    }
  }

  /**
   * A expression that is equivalent to `A.includes(B)` or `!A.includes(B)`.
   *
   * Note that this also includes calls to the array method named `includes`.
   */
  abstract class Includes extends DataFlow::Node {
    /** Gets the `A` in `A.includes(B)`. */
    abstract DataFlow::Node getBaseString();

    /** Gets the `B` in `A.includes(B)`. */
    abstract DataFlow::Node getSubstring();

    /**
     * Gets the polarity of the check.
     *
     * If the polarity is `false` the check returns `true` if the string does not contain
     * the given substring.
     */
    boolean getPolarity() { result = true }
  }

  /**
   * A call to a method named `includes`, assumed to refer to `String.prototype.includes`.
   */
  private class Includes_Native extends Includes, DataFlow::MethodCallNode {
    Includes_Native() {
      getMethodName() = "includes" and
      getNumArgument() = 1
    }

    override DataFlow::Node getBaseString() {
      result = getReceiver()
    }

    override DataFlow::Node getSubstring() {
      result = getArgument(0)
    }
  }

  /**
   * A call to `_.includes` or similar, assumed to operate on strings.
   */
  private class Includes_Library extends Includes, DataFlow::CallNode {
    Includes_Library() {
      exists (string name |
        this = LodashUnderscore::member(name).getACall() and
        (name = "includes" or name = "include" or name = "contains")
      )
    }

    override DataFlow::Node getBaseString() {
      result = getArgument(0)
    }

    override DataFlow::Node getSubstring() {
      result = getArgument(1)
    }
  }

  /**
   * A check of form `A.indexOf(B) !== -1` or similar.
   */
  private class Includes_IndexOfEquals extends Includes, DataFlow::ValueNode {
    MethodCallExpr indexOf;
    override EqualityTest astNode;

    Includes_IndexOfEquals() {
      exists (Expr index | astNode.hasOperands(indexOf, index) |
        // one operand is of the form `whitelist.indexOf(x)`
        indexOf.getMethodName() = "indexOf" and
        // and the other one is -1
        index.getIntValue() = -1
      )
    }

    override DataFlow::Node getBaseString() {
      result = indexOf.getReceiver().flow()
    }

    override DataFlow::Node getSubstring() {
      result = indexOf.getArgument(0).flow()
    }

    override boolean getPolarity() {
      result = astNode.getPolarity().booleanNot()
    }
  }

  /**
   * A check of form `A.indexOf(B) >= 0` or similar.
   */
  private class Includes_IndexOfRelational extends Includes, DataFlow::ValueNode {
    MethodCallExpr indexOf;
    override RelationalComparison astNode;
    boolean polarity;

    Includes_IndexOfRelational() {
      exists (Expr lesser, Expr greater |
        astNode.getLesserOperand() = lesser and
        astNode.getGreaterOperand() = greater and
        indexOf.getMethodName() = "indexOf" and
        indexOf.getNumArgument() = 1 |
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

    override DataFlow::Node getBaseString() {
      result = indexOf.getReceiver().flow()
    }

    override DataFlow::Node getSubstring() {
      result = indexOf.getArgument(0).flow()
    }

    override boolean getPolarity() {
      result = polarity
    }
  }

  /**
   * An expression of form `~A.indexOf(B)` which, when coerced to a boolean, is equivalent to `A.includes(B)`.
   */
  private class Includes_IndexOfBitwise extends Includes, DataFlow::ValueNode {
    MethodCallExpr indexOf;
    override BitNotExpr astNode;

    Includes_IndexOfBitwise() {
      astNode.getOperand() = indexOf and
      indexOf.getMethodName() = "indexOf"
    }

    override DataFlow::Node getBaseString() {
      result = indexOf.getReceiver().flow()
    }

    override DataFlow::Node getSubstring() {
      result = indexOf.getArgument(0).flow()
    }
  }

  /**
   * An expression that is equivalent to `A.endsWith(B)` or `!A.endsWith(B)`.
   */
  abstract class EndsWith extends DataFlow::Node {
    /**
     * Gets the `A` in `A.startsWith(B)`.
     */
    abstract DataFlow::Node getBaseString();

    /**
     * Gets the `B` in `A.startsWith(B)`.
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
   * A call of form `A.endsWith(B)`.
   */
  private class EndsWith_Native extends EndsWith, DataFlow::MethodCallNode {
    EndsWith_Native() {
      getMethodName() = "endsWith" and
      getNumArgument() = 1
    }

    override DataFlow::Node getBaseString() {
      result = getReceiver()
    }

    override DataFlow::Node getSubstring() {
      result = getArgument(0)
    }
  }

  /**
   * A call of form `_.endsWith(A, B)` or `ramda.endsWith(A, B)`.
   */
  private class EndsWith_Library extends StartsWith, DataFlow::CallNode {
    EndsWith_Library() {
      getNumArgument() = 2 and
      exists (DataFlow::SourceNode callee | this = callee.getACall() |
        callee = LodashUnderscore::member("endsWith") or
        callee = DataFlow::moduleMember("ramda", "endsWith")
      )
    }

    override DataFlow::Node getBaseString() {
      result = getArgument(0)
    }

    override DataFlow::Node getSubstring() {
      result = getArgument(1)
    }
  }
}
