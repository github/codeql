/**
 * Provides classes and predicates for reasoning about string-manipulating expressions.
 */

import javascript

module StringOps {
  /**
   * A expression that is equivalent to `A.startsWith(B)` or `!A.startsWith(B)`.
   */
  class StartsWith extends DataFlow::Node {
    StartsWith::Range range;

    StartsWith() { range = this }

    /**
     * Gets the `A` in `A.startsWith(B)`.
     */
    DataFlow::Node getBaseString() { result = range.getBaseString() }

    /**
     * Gets the `B` in `A.startsWith(B)`.
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

  module StartsWith {
    /**
     * A expression that is equivalent to `A.startsWith(B)` or `!A.startsWith(B)`.
     */
    abstract class Range extends DataFlow::Node {
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
     * A call to a utility function (`callee`) that performs a StartsWith check (`inner`).
     */
    private class IndirectStartsWith extends Range, DataFlow::CallNode {
      StartsWith inner;
      Function callee;

      IndirectStartsWith() {
        inner.getEnclosingExpr() = unique(Expr ret | ret = callee.getAReturnedExpr()) and
        callee = unique(Function f | f = this.getACallee()) and
        not this.isImprecise() and
        inner.getBaseString().getALocalSource().getEnclosingExpr() = callee.getAParameter() and
        inner.getSubstring().getALocalSource().getEnclosingExpr() = callee.getAParameter()
      }

      override DataFlow::Node getBaseString() {
        exists(int arg |
          inner.getBaseString().getALocalSource().getEnclosingExpr() = callee.getParameter(arg) and
          result = this.getArgument(arg)
        )
      }

      override DataFlow::Node getSubstring() {
        exists(int arg |
          inner.getSubstring().getALocalSource().getEnclosingExpr() = callee.getParameter(arg) and
          result = this.getArgument(arg)
        )
      }

      override boolean getPolarity() { result = inner.getPolarity() }
    }

    /**
     * An expression of form `A.startsWith(B)`.
     */
    private class StartsWith_Native extends Range, DataFlow::MethodCallNode {
      StartsWith_Native() {
        getMethodName() = "startsWith" and
        getNumArgument() = 1
      }

      override DataFlow::Node getBaseString() { result = getReceiver() }

      override DataFlow::Node getSubstring() { result = getArgument(0) }
    }

    /**
     * An expression of form `A.indexOf(B) === 0`.
     */
    private class StartsWith_IndexOfEquals extends Range, DataFlow::ValueNode {
      override EqualityTest astNode;
      DataFlow::MethodCallNode indexOf;

      StartsWith_IndexOfEquals() {
        indexOf.getMethodName() = "indexOf" and
        indexOf.getNumArgument() = 1 and
        indexOf.flowsToExpr(astNode.getAnOperand()) and
        astNode.getAnOperand().getIntValue() = 0
      }

      override DataFlow::Node getBaseString() { result = indexOf.getReceiver() }

      override DataFlow::Node getSubstring() { result = indexOf.getArgument(0) }

      override boolean getPolarity() { result = astNode.getPolarity() }
    }

    /**
     * An expression of form `A.indexOf(B)` coerced to a boolean.
     *
     * This is equivalent to `!A.startsWith(B)` since all return values other than zero map to `true`.
     */
    private class StartsWith_IndexOfCoercion extends Range, DataFlow::MethodCallNode {
      StartsWith_IndexOfCoercion() {
        getMethodName() = "indexOf" and
        getNumArgument() = 1 and
        this.flowsToExpr(any(ConditionGuardNode guard).getTest()) // check for boolean coercion
      }

      override DataFlow::Node getBaseString() { result = getReceiver() }

      override DataFlow::Node getSubstring() { result = getArgument(0) }

      override boolean getPolarity() { result = false }
    }

    /**
     * A call of form `_.startsWith(A, B)` or `ramda.startsWith(A, B)` or `goog.string.startsWith(A, B)`.
     */
    private class StartsWith_Library extends Range, DataFlow::CallNode {
      StartsWith_Library() {
        getNumArgument() = 2 and
        exists(DataFlow::SourceNode callee | this = callee.getACall() |
          callee = LodashUnderscore::member("startsWith")
          or
          callee = DataFlow::moduleMember("ramda", "startsWith")
          or
          exists(string name |
            callee = Closure::moduleImport("goog.string." + name) and
            (name = "startsWith" or name = "caseInsensitiveStartsWith")
          )
        )
      }

      override DataFlow::Node getBaseString() { result = getArgument(0) }

      override DataFlow::Node getSubstring() { result = getArgument(1) }
    }

    /**
     * A comparison of form `x[0] === "k"` for some single-character constant `k`.
     */
    private class StartsWith_FirstCharacter extends Range, DataFlow::ValueNode {
      override EqualityTest astNode;
      DataFlow::PropRead read;
      Expr constant;

      StartsWith_FirstCharacter() {
        read.flowsTo(astNode.getAnOperand().flow()) and
        read.getPropertyNameExpr().getIntValue() = 0 and
        constant.getStringValue().length() = 1 and
        astNode.getAnOperand() = constant
      }

      override DataFlow::Node getBaseString() { result = read.getBase() }

      override DataFlow::Node getSubstring() { result = constant.flow() }

      override boolean getPolarity() { result = astNode.getPolarity() }
    }

    /**
     * A comparison of form `x.substring(0, y.length) === y`.
     */
    private class StartsWith_Substring extends Range, DataFlow::ValueNode {
      override EqualityTest astNode;
      DataFlow::MethodCallNode call;
      DataFlow::Node substring;

      StartsWith_Substring() {
        astNode.hasOperands(call.asExpr(), substring.asExpr()) and
        (
          call.getMethodName() = "substring" or
          call.getMethodName() = "substr" or
          call.getMethodName() = "slice"
        ) and
        call.getNumArgument() = 2 and
        (
          AccessPath::getAnAliasedSourceNode(substring)
              .getAPropertyRead("length")
              .flowsTo(call.getArgument(1))
          or
          substring.getStringValue().length() = call.getArgument(1).asExpr().getIntValue()
        )
      }

      override DataFlow::Node getBaseString() { result = call.getReceiver() }

      override DataFlow::Node getSubstring() { result = substring }

      override boolean getPolarity() { result = astNode.getPolarity() }
    }
  }

  /**
   * A expression that is equivalent to `A.includes(B)` or `!A.includes(B)`.
   *
   * Note that this class is equivalent to `InclusionTest`, which also matches
   * inclusion tests on array objects.
   */
  class Includes extends InclusionTest {
    /** Gets the `A` in `A.includes(B)`. */
    DataFlow::Node getBaseString() { result = getContainerNode() }

    /** Gets the `B` in `A.includes(B)`. */
    DataFlow::Node getSubstring() { result = getContainedNode() }
  }

  /**
   * An expression that is equivalent to `A.endsWith(B)` or `!A.endsWith(B)`.
   */
  class EndsWith extends DataFlow::Node {
    EndsWith::Range range;

    EndsWith() { this = range }

    /**
     * Gets the `A` in `A.startsWith(B)`.
     */
    DataFlow::Node getBaseString() { result = range.getBaseString() }

    /**
     * Gets the `B` in `A.startsWith(B)`.
     */
    DataFlow::Node getSubstring() { result = range.getSubstring() }

    /**
     * Gets the polarity if the check.
     *
     * If the polarity is `false` the check returns `true` if the string does not end
     * with the given substring.
     */
    boolean getPolarity() { result = range.getPolarity() }
  }

  module EndsWith {
    /**
     * An expression that is equivalent to `A.endsWith(B)` or `!A.endsWith(B)`.
     */
    abstract class Range extends DataFlow::Node {
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
     * A call to a utility function (`callee`) that performs an EndsWith check (`inner`).
     */
    private class IndirectEndsWith extends Range, DataFlow::CallNode {
      EndsWith inner;
      Function callee;

      IndirectEndsWith() {
        inner.getEnclosingExpr() = unique(Expr ret | ret = callee.getAReturnedExpr()) and
        callee = unique(Function f | f = this.getACallee()) and
        not this.isImprecise() and
        inner.getBaseString().getALocalSource().getEnclosingExpr() = callee.getAParameter() and
        inner.getSubstring().getALocalSource().getEnclosingExpr() = callee.getAParameter()
      }

      override DataFlow::Node getBaseString() {
        exists(int arg |
          inner.getBaseString().getALocalSource().getEnclosingExpr() = callee.getParameter(arg) and
          result = this.getArgument(arg)
        )
      }

      override DataFlow::Node getSubstring() {
        exists(int arg |
          inner.getSubstring().getALocalSource().getEnclosingExpr() = callee.getParameter(arg) and
          result = this.getArgument(arg)
        )
      }

      override boolean getPolarity() { result = inner.getPolarity() }
    }

    /**
     * A call of form `A.endsWith(B)`.
     */
    private class EndsWith_Native extends Range, DataFlow::MethodCallNode {
      EndsWith_Native() {
        getMethodName() = "endsWith" and
        getNumArgument() = 1
      }

      override DataFlow::Node getBaseString() { result = getReceiver() }

      override DataFlow::Node getSubstring() { result = getArgument(0) }
    }

    /**
     * A call of form `_.endsWith(A, B)` or `ramda.endsWith(A, B)`.
     */
    private class EndsWith_Library extends Range, DataFlow::CallNode {
      EndsWith_Library() {
        getNumArgument() = 2 and
        exists(DataFlow::SourceNode callee | this = callee.getACall() |
          callee = LodashUnderscore::member("endsWith")
          or
          callee = DataFlow::moduleMember("ramda", "endsWith")
          or
          exists(string name |
            callee = Closure::moduleImport("goog.string." + name) and
            (name = "endsWith" or name = "caseInsensitiveEndsWith")
          )
        )
      }

      override DataFlow::Node getBaseString() { result = getArgument(0) }

      override DataFlow::Node getSubstring() { result = getArgument(1) }
    }
  }

  /**
   * Holds if `first` and `second` are adjacent leaves in a concatenation tree.
   */
  pragma[nomagic]
  private predicate adjacentLeaves(ConcatenationLeaf first, ConcatenationLeaf second) {
    exists(Concatenation parent, int i |
      first = parent.getOperand(i).getLastLeaf() and
      second = parent.getOperand(i + 1).getFirstLeaf()
    )
  }

  /**
   * A data flow node that performs a string concatenation or occurs as an operand
   * in a string concatenation.
   *
   * For example, the expression `x + y + z` contains the following concatenation
   * nodes:
   * - The leaf nodes `x`, `y`, and `z`
   * - The intermediate node `x + y`, which is both a concatenation and an operand
   * - The root node `x + y + z`
   *
   *
   * Note that the following are not recognized a string concatenations:
   * - Array `join()` calls with a non-empty separator
   * - Tagged template literals
   *
   *
   * Also note that all `+` operators are seen as string concatenations,
   * even in cases where it is used for arithmetic.
   *
   * Examples of string concatenations:
   * ```
   * x + y
   * x += y
   * [x, y].join('')
   * Array(x, y).join('')
   * `Hello, ${message}`
   * ```
   */
  class ConcatenationNode extends DataFlow::Node {
    pragma[inline]
    ConcatenationNode() {
      exists(StringConcatenation::getAnOperand(this))
      or
      this = StringConcatenation::getAnOperand(_)
    }

    /**
     * Gets the `n`th operand of this string concatenation.
     */
    pragma[inline]
    ConcatenationOperand getOperand(int n) { result = StringConcatenation::getOperand(this, n) }

    /**
     * Gets an operand of this string concatenation.
     */
    pragma[inline]
    ConcatenationOperand getAnOperand() { result = StringConcatenation::getAnOperand(this) }

    /**
     * Gets the number of operands of this string concatenation.
     */
    pragma[inline]
    int getNumOperand() { result = StringConcatenation::getNumOperand(this) }

    /**
     * Gets the first operand of this string concatenation.
     */
    pragma[inline]
    ConcatenationOperand getFirstOperand() { result = StringConcatenation::getFirstOperand(this) }

    /**
     * Gets the last operand of this string concatenation
     */
    pragma[inline]
    ConcatenationOperand getLastOperand() { result = StringConcatenation::getLastOperand(this) }

    /**
     * Holds if this only acts as a string coercion, such as `"" + x`.
     */
    pragma[inline]
    predicate isCoercion() { StringConcatenation::isCoercion(this) }

    /**
     * Holds if this is the root of a concatenation tree, that is,
     * it is a concatenation operator that is not itself the immediate operand to
     * another concatenation operator.
     */
    pragma[inline]
    predicate isRoot() { StringConcatenation::isRoot(this) }

    /**
     * Holds if this is a leaf in the concatenation tree, that is, it is not
     * itself a concatenation.
     */
    pragma[inline]
    predicate isLeaf() { not exists(StringConcatenation::getAnOperand(this)) }

    /**
     * Gets the root of the concatenation tree in which this is an operator.
     */
    pragma[inline]
    ConcatenationRoot getRoot() { result = StringConcatenation::getRoot(this) }

    /**
     * Gets the enclosing concatenation in which this is an operand, if any.
     */
    pragma[inline]
    Concatenation getParentConcatenation() { this = StringConcatenation::getAnOperand(result) }

    /**
     * Gets the last leaf in this concatenation tree.
     *
     * For example, `z` is the last leaf in `x + y + z`.
     */
    pragma[inline]
    ConcatenationLeaf getLastLeaf() { result = StringConcatenation::getLastOperand*(this) }

    /**
     * Gets the first leaf in this concatenation tree.
     *
     * For example, `x` is the first leaf in `x + y + z`.
     */
    pragma[inline]
    ConcatenationLeaf getFirstLeaf() { result = StringConcatenation::getFirstOperand*(this) }

    /**
     * Gets the leaf that is occurs immediately before this leaf in the
     * concatenation tree, if any.
     *
     * For example, `y` is the previous leaf from `z` in `x + y + z`.
     */
    pragma[inline]
    ConcatenationLeaf getPreviousLeaf() { adjacentLeaves(result, this) }

    /**
     * Gets the leaf that is occurs immediately after this leaf in the
     * concatenation tree, if any.
     *
     * For example, `y` is the next leaf from `x` in `x + y + z`.
     */
    pragma[inline]
    ConcatenationLeaf getNextLeaf() { adjacentLeaves(this, result) }
  }

  /**
   * A data flow node that performs a string concatenation and returns the result.
   *
   * Examples:
   * ```
   * x + y
   * x += y
   * [x, y].join('')
   * Array(x, y).join('')
   * `Hello ${message}`
   * ```
   *
   * See `ConcatenationNode` for more information.
   */
  class Concatenation extends ConcatenationNode {
    pragma[inline]
    Concatenation() { exists(StringConcatenation::getAnOperand(this)) }
  }

  /**
   * One of the operands in a string concatenation.
   *
   * Examples:
   * ```
   * x + y              // x and y are operands
   * [x, y].join('')    // x and y are operands
   * `Hello ${message}` // `Hello ` and message are operands
   * ```
   *
   * See `ConcatenationNode` for more information.
   */
  class ConcatenationOperand extends ConcatenationNode {
    pragma[inline]
    ConcatenationOperand() { this = StringConcatenation::getAnOperand(_) }
  }

  /**
   * A data flow node that performs a string concatenation, and is not an
   * immediate operand in a larger string concatenation.
   *
   * Examples:
   * ```
   * // x + y + z is a root, but the inner x + y is not
   * return x + y + z;
   * ```
   *
   * See `ConcatenationNode` for more information.
   */
  class ConcatenationRoot extends Concatenation {
    pragma[inline]
    ConcatenationRoot() { isRoot() }

    /**
     * Gets a leaf in this concatenation tree that this node is the root of.
     */
    pragma[inline]
    ConcatenationLeaf getALeaf() { this = StringConcatenation::getRoot(result) }

    /**
     * Returns the concatenation of all constant operands in this concatenation,
     * ignoring the non-constant parts entirely.
     *
     * For example, for the following concatenation
     * ```
     * `Hello ${person}, how are you?`
     * ```
     * the result is `"Hello , how are you?"`
     */
    string getConstantStringParts() {
      result = getStringValue()
      or
      not exists(getStringValue()) and
      result =
        strictconcat(StringLiteralLike leaf |
          leaf = getALeaf().asExpr()
        |
          leaf.getStringValue() order by leaf.getFirstToken().getIndex()
        )
    }
  }

  /** A string literal or template literal without any substitutions. */
  private class StringLiteralLike extends Expr {
    StringLiteralLike() {
      this instanceof StringLiteral or
      this instanceof TemplateElement
    }
  }

  /**
   * An operand to a concatenation that is not itself a concatenation.
   *
   * Example:
   * ```
   * x + y + z            // x, y, and z are leaves
   * [x, y + z].join('')  // x, y, and z are leaves
   * ```
   *
   * See `ConcatenationNode` for more information.
   */
  class ConcatenationLeaf extends ConcatenationOperand {
    pragma[inline]
    ConcatenationLeaf() { isLeaf() }
  }

  /**
   * The root node in a concatenation of one or more strings containing HTML fragments.
   */
  class HtmlConcatenationRoot extends ConcatenationRoot {
    pragma[noinline]
    HtmlConcatenationRoot() {
      getConstantStringParts().regexpMatch("(?s).*</?[a-zA-Z][^\\r\\n<>/]*/?>.*")
    }
  }

  /**
   * A data flow node that is part of an HTML string concatenation.
   */
  class HtmlConcatenationNode extends ConcatenationNode {
    HtmlConcatenationNode() { getRoot() instanceof HtmlConcatenationRoot }
  }

  /**
   * A data flow node that is part of an HTML string concatenation,
   * and is not itself a concatenation operator.
   */
  class HtmlConcatenationLeaf extends ConcatenationLeaf {
    HtmlConcatenationLeaf() { getRoot() instanceof HtmlConcatenationRoot }
  }
}
