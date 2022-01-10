/**
 * Provides predicates and classes for working with string operations.
 */

import go

/** Provides predicates and classes for working with string operations. */
module StringOps {
  /**
   * An expression that is equivalent to `strings.HasPrefix(A, B)` or `!strings.HasPrefix(A, B)`.
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
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

  /** Provides predicates and classes for working with prefix checks. */
  module HasPrefix {
    /**
     * An expression that is equivalent to `strings.HasPrefix(A, B)` or `!strings.HasPrefix(A, B)`.
     *
     * Extend this class to model new APIs. If you want to refine existing API models, extend
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
     * An expression of the form `strings.HasPrefix(A, B)`.
     */
    private class StringsHasPrefix extends Range, DataFlow::CallNode {
      StringsHasPrefix() { this.getTarget().hasQualifiedName("strings", "HasPrefix") }

      override DataFlow::Node getBaseString() { result = this.getArgument(0) }

      override DataFlow::Node getSubstring() { result = this.getArgument(1) }
    }

    /**
     * Holds if `eq` is of the form `nd == 0` or `nd != 0`.
     */
    pragma[noinline]
    private predicate comparesToZero(DataFlow::EqualityTestNode eq, DataFlow::Node nd) {
      exists(DataFlow::Node zero |
        eq.hasOperands(globalValueNumber(nd).getANode(), zero) and
        zero.getIntValue() = 0
      )
    }

    /**
     * An expression of the form `strings.Index(A, B) == 0`.
     */
    private class HasPrefix_IndexOfEquals extends Range, DataFlow::EqualityTestNode {
      DataFlow::CallNode indexOf;

      HasPrefix_IndexOfEquals() {
        comparesToZero(this, indexOf) and
        indexOf.getTarget().hasQualifiedName("strings", "Index")
      }

      override DataFlow::Node getBaseString() { result = indexOf.getArgument(0) }

      override DataFlow::Node getSubstring() { result = indexOf.getArgument(1) }

      override boolean getPolarity() { result = expr.getPolarity() }
    }

    /**
     * Holds if `eq` is of the form `str[0] == rhs` or `str[0] != rhs`.
     */
    pragma[noinline]
    private predicate comparesFirstCharacter(
      DataFlow::EqualityTestNode eq, DataFlow::Node str, DataFlow::Node rhs
    ) {
      exists(DataFlow::ElementReadNode read |
        eq.hasOperands(globalValueNumber(read).getANode(), rhs) and
        str = read.getBase() and
        str.getType().getUnderlyingType() instanceof StringType and
        read.getIndex().getIntValue() = 0
      )
    }

    /**
     * A comparison of the form `x[0] == 'k'` for some rune literal `k`.
     */
    private class HasPrefix_FirstCharacter extends Range, DataFlow::EqualityTestNode {
      DataFlow::Node base;
      DataFlow::Node runeLiteral;

      HasPrefix_FirstCharacter() { comparesFirstCharacter(this, base, runeLiteral) }

      override DataFlow::Node getBaseString() { result = base }

      override DataFlow::Node getSubstring() { result = runeLiteral }

      override boolean getPolarity() { result = expr.getPolarity() }
    }

    /**
     * A comparison of the form `x[:len(y)] == y`.
     */
    private class HasPrefix_Substring extends Range, DataFlow::EqualityTestNode {
      DataFlow::SliceNode slice;
      DataFlow::Node substring;

      HasPrefix_Substring() {
        this.eq(_, slice, substring) and
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

  /** Provides predicates and classes for working with Printf-style formatters. */
  module Formatting {
    /**
     * Gets a regular expression for matching simple format-string components, including flags,
     * width and precision specifiers, not including explicit argument indices.
     */
    pragma[noinline]
    private string getFormatComponentRegex() {
      exists(
        string literal, string opt_flag, string width, string prec, string opt_width_and_prec,
        string operator, string verb
      |
        literal = "([^%]|%%)+" and
        opt_flag = "[-+ #0]?" and
        width = "\\d+|\\*" and
        prec = "\\.(\\d+|\\*)" and
        opt_width_and_prec = "(" + width + ")?(" + prec + ")?" and
        operator = "[bcdeEfFgGoOpqstTxXUv]" and
        verb = "(%" + opt_flag + opt_width_and_prec + operator + ")"
      |
        result = "(" + literal + "|" + verb + ")"
      )
    }

    /**
     * A function that performs string formatting in the same manner as `fmt.Printf` etc.
     */
    abstract class Range extends Function {
      /**
       * Gets the parameter index of the format string.
       */
      abstract int getFormatStringIndex();

      /**
       * Gets the parameter index of the first parameter to be formatted.
       */
      abstract int getFirstFormattedParameterIndex();
    }

    /**
     * A call to a `fmt.Printf`-style string formatting function.
     */
    class StringFormatCall extends DataFlow::CallNode {
      string fmt;
      Range f;

      StringFormatCall() {
        this = f.getACall() and
        fmt = this.getArgument(f.getFormatStringIndex()).getStringValue() and
        fmt.regexpMatch(getFormatComponentRegex() + "*")
      }

      /**
       * Gets the `n`th component of this format string.
       */
      string getComponent(int n) { result = fmt.regexpFind(getFormatComponentRegex(), n, _) }

      /**
       * Gets the `n`th argument formatted by this format call, where `formatDirective` specifies how it will be formatted.
       */
      DataFlow::Node getOperand(int n, string formatDirective) {
        formatDirective = this.getComponent(n) and
        formatDirective.charAt(0) = "%" and
        formatDirective.charAt(1) != "%" and
        result = this.getArgument((n / 2) + f.getFirstFormattedParameterIndex())
      }
    }
  }

  /**
   * A data-flow node that performs string concatenation.
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
   * extend `StringOps::Concatenation::Range` instead.
   */
  class Concatenation extends DataFlow::Node {
    Concatenation::Range self;

    Concatenation() { this = self }

    /**
     * Gets the `n`th operand of this string concatenation, if there is a data-flow node for it.
     */
    DataFlow::Node getOperand(int n) { result = self.getOperand(n) }

    /**
     * Gets the string value of the `n`th operand of this string concatenation, if it is a constant.
     */
    string getOperandStringValue(int n) { result = self.getOperandStringValue(n) }

    /**
     * Gets the number of operands of this string concatenation.
     */
    int getNumOperand() { result = self.getNumOperand() }
  }

  /** Provides predicates and classes for working with string concatenations. */
  module Concatenation {
    /**
     * A data-flow node that performs string concatenation.
     *
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `StringOps::Concatenation` instead.
     */
    abstract class Range extends DataFlow::Node {
      /**
       * Gets the `n`th operand of this string concatenation, if there is a data-flow node for it.
       */
      abstract DataFlow::Node getOperand(int n);

      /**
       * Gets the string value of the `n`th operand of this string concatenation, if it is
       * a constant.
       */
      string getOperandStringValue(int n) { result = this.getOperand(n).getStringValue() }

      /**
       * Gets the number of operands of this string concatenation.
       */
      int getNumOperand() { result = count(this.getOperand(_)) }
    }

    /** A string concatenation using the `+` or `+=` operator. */
    private class PlusConcat extends Range, DataFlow::BinaryOperationNode {
      PlusConcat() {
        this.getType() instanceof StringType and
        this.getOperator() = "+"
      }

      override DataFlow::Node getOperand(int n) {
        n = 0 and result = this.getLeftOperand()
        or
        n = 1 and result = this.getRightOperand()
      }
    }

    /**
     * A call to `fmt.Sprintf`, considered as a string concatenation.
     *
     * Only calls with simple format strings (no `*` specifiers, no explicit argument indices)
     * are supported. Such format strings can be viewed as sequences of alternating literal and
     * non-literal components. A literal component contains no `%` characters except `%%` pairs,
     * while a non-literal component consists of `%`, a verb, and possibly flags and specifiers.
     * Each non-literal component consumes exactly one argument.
     *
     * Literal components give rise to concatenation operands that have a string value but no
     * data-flow node; non-literal `%s` or `%v` components give rise to concatenation operands
     * that do have an associated data-flow node but possibly no string value; any other non-literal
     * components give rise to concatenation operands that have neither an associated data-flow
     * node nor a string value. This is because verbs like `%q` perform additional string
     * transformations that we cannot easily represent.
     */
    private class SprintfConcat extends Range instanceof Formatting::StringFormatCall {
      SprintfConcat() { this = any(Function f | f.hasQualifiedName("fmt", "Sprintf")).getACall() }

      override DataFlow::Node getOperand(int n) {
        result = Formatting::StringFormatCall.super.getOperand(n, ["%s", "%v"])
      }

      override string getOperandStringValue(int n) {
        result = Range.super.getOperandStringValue(n)
        or
        exists(string cmp | cmp = Formatting::StringFormatCall.super.getComponent(n) |
          (cmp.charAt(0) != "%" or cmp.charAt(1) = "%") and
          result = cmp.replaceAll("%%", "%")
        )
      }

      override int getNumOperand() {
        result = max(int i | exists(Formatting::StringFormatCall.super.getComponent(i))) + 1
      }
    }

    /**
     * Holds if `src` flows to `dst` through the `n`th operand of the given concatenation operator.
     */
    predicate taintStep(DataFlow::Node src, DataFlow::Node dst, Concatenation cat, int n) {
      src = cat.getOperand(n) and
      dst = cat
    }

    /**
     * Holds if there is a taint step from `src` to `dst` through string concatenation.
     */
    predicate taintStep(DataFlow::Node src, DataFlow::Node dst) { taintStep(src, dst, _, _) }
  }

  private newtype TConcatenationElement =
    /** A root concatenation element that is not itself an operand of a string concatenation. */
    MkConcatenationRoot(Concatenation cat) { not cat = any(Concatenation parent).getOperand(_) } or
    /** A concatenation element that is an operand of a string concatenation. */
    MkConcatenationOperand(Concatenation parent, int i) { i in [0 .. parent.getNumOperand() - 1] }

  /**
   * An element of a string concatenation, which either itself performs a string concatenation or
   * occurs as an operand in a string concatenation.
   *
   * For example, the expression `x + y + z` contains the following concatenation
   * elements:
   *
   * - The leaf elements `x`, `y`, and `z`
   * - The intermediate element `x + y`, which is both a concatenation and an operand
   * - The root element `x + y + z`
   */
  class ConcatenationElement extends TConcatenationElement {
    /**
     * Gets the data-flow node corresponding to this concatenation element, if any.
     */
    DataFlow::Node asNode() {
      this = MkConcatenationRoot(result)
      or
      exists(Concatenation parent, int i | this = MkConcatenationOperand(parent, i) |
        result = parent.getOperand(i)
      )
    }

    /**
     * Gets the string value of this concatenation element if it is a constant.
     */
    string getStringValue() {
      result = this.asNode().getStringValue()
      or
      exists(Concatenation parent, int i | this = MkConcatenationOperand(parent, i) |
        result = parent.getOperandStringValue(i)
      )
    }

    /**
     * Gets the `n`th operand of this string concatenation.
     */
    ConcatenationOperand getOperand(int n) { result = MkConcatenationOperand(this.asNode(), n) }

    /**
     * Gets an operand of this string concatenation.
     */
    ConcatenationOperand getAnOperand() { result = this.getOperand(_) }

    /**
     * Gets the number of operands of this string concatenation.
     */
    int getNumOperand() { result = count(this.getAnOperand()) }

    /**
     * Gets the first operand of this string concatenation.
     *
     * For example, the first operand of `(x + y) + z` is `(x + y)`.
     */
    ConcatenationOperand getFirstOperand() { result = this.getOperand(0) }

    /**
     * Gets the last operand of this string concatenation.
     *
     * For example, the last operand of `x + (y + z)` is `(y + z)`.
     */
    ConcatenationOperand getLastOperand() { result = this.getOperand(this.getNumOperand() - 1) }

    /**
     * Gets the root of the concatenation tree to which this element belongs.
     */
    ConcatenationRoot getConcatenationRoot() { this = result.getAnOperand*() }

    /**
     * Gets a leaf in the concatenation tree that this element is the root of.
     */
    ConcatenationLeaf getALeaf() { result = this.getAnOperand*() }

    /**
     * Gets the first leaf in this concatenation tree.
     *
     * For example, the first leaf of `(x + y) + z` is `x`.
     */
    ConcatenationLeaf getFirstLeaf() { result = this.getFirstOperand*() }

    /**
     * Gets the last leaf in this concatenation tree.
     *
     * For example, the last leaf of `x + (y + z)` is `z`.
     */
    ConcatenationLeaf getLastLeaf() { result = this.getLastOperand*() }

    /** Gets a textual representation of this concatenation element. */
    string toString() {
      if exists(this.asNode())
      then result = this.asNode().toString()
      else
        if exists(this.getStringValue())
        then result = this.getStringValue()
        else result = "concatenation element"
    }

    /**
     * Holds if this element is at the specified location.
     * The location spans column `startcolumn` of line `startline` to
     * column `endcolumn` of line `endline` in file `filepath`.
     * For more information, see
     * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
     */
    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      this.asNode().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
      or
      // use dummy location for elements that don't have a corresponding node
      not exists(this.asNode()) and
      filepath = "" and
      startline = 0 and
      startcolumn = 0 and
      endline = 0 and
      endcolumn = 0
    }
  }

  /**
   * One of the operands in a string concatenation.
   *
   * See `ConcatenationElement` for more information.
   */
  class ConcatenationOperand extends ConcatenationElement, MkConcatenationOperand { }

  /**
   * A data-flow node that performs a string concatenation, and is not an
   * immediate operand in a larger string concatenation.
   *
   * See `ConcatenationElement` for more information.
   */
  class ConcatenationRoot extends ConcatenationElement, MkConcatenationRoot { }

  /**
   * An operand to a concatenation that is not itself a concatenation.
   *
   * See `ConcatenationElement` for more information.
   */
  class ConcatenationLeaf extends ConcatenationOperand {
    ConcatenationLeaf() { not exists(this.getAnOperand()) }

    /**
     * Gets the operand immediately preceding this one in its parent concatenation.
     *
     * For example, in `(x + y) + z`, the previous leaf for `z` is `y`.
     */
    ConcatenationLeaf getPreviousLeaf() {
      exists(ConcatenationElement parent, int i |
        result = parent.getOperand(i - 1).getLastLeaf() and
        this = parent.getOperand(i).getFirstLeaf()
      )
    }

    /**
     * Gets the operand immediately succeeding this one in its parent concatenation.
     *
     * For example, in `(x + y) + z`, the previous leaf for `y` is `z`.
     */
    ConcatenationLeaf getNextLeaf() { this = result.getPreviousLeaf() }
  }
}
