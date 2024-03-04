/**
 * Provides classes and predicates for identifying expressions that may be appended to an interesting prefix.
 *
 * To use this library, extend the abstract class `InterestingPrefix` to have the library identify expressions that
 * may be appended to it, then check `InterestingPrefix.getAnAppendedExpression(Expr)` to get your results.
 *
 * For example, to identify expressions that may follow "foo:" in some string, we could define:
 *
 * ```
 * private class FooPrefix extends InterestingPrefix {
 *   int offset;
 *   FooPrefix() { this.getStringValue().substring("foo:") = offset };
 *   override int getOffset() { result = offset }
 * };
 *
 * predicate mayFollowFoo(Expr e) { e = any(FooPrefix fp).getAnAppendedExpression() }
 * ```
 *
 * This will identify all the `suffix` expressions in contexts such as:
 *
 * ```
 * "foo:" + suffix1
 * "barfoo:" + suffix2
 * stringBuilder.append("foo:").append(suffix3);
 * String.format("%sfoo:%s", notSuffix, suffix4);
 * ```
 */

import java
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.StringFormat

/**
 * A string constant that contains a prefix whose possibly-appended strings are
 * returned by `getAnAppendedExpression`.
 *
 * Extend this class to specify prefixes whose possibly-appended strings should be analyzed.
 */
abstract class InterestingPrefix extends CompileTimeConstantExpr {
  /**
   * Gets the offset in this constant string where the interesting prefix begins.
   */
  abstract int getOffset();

  /**
   * Gets an expression that may follow this prefix in a derived string.
   */
  Expr getAnAppendedExpression() { mayFollowInterestingPrefix(this, result) }
}

private Expr getAnInterestingPrefix(InterestingPrefix root) {
  result = root
  or
  result.(AddExpr).getAnOperand() = getAnInterestingPrefix(root)
}

private class StringBuilderAppend extends MethodCall {
  StringBuilderAppend() {
    this.getMethod().getDeclaringType() instanceof StringBuildingType and
    this.getMethod().hasName("append")
  }
}

private class StringBuilderConstructorOrAppend extends Call {
  StringBuilderConstructorOrAppend() {
    this instanceof StringBuilderAppend or
    this.(ClassInstanceExpr).getConstructedType() instanceof StringBuildingType
  }
}

private Expr getQualifier(Expr e) { result = e.(MethodCall).getQualifier() }

/**
 * An extension of `StringBuilderVar` that also accounts for strings appended in StringBuilder/Buffer's constructor
 * and in `append` calls chained onto the constructor call.
 *
 * The original `StringBuilderVar` doesn't care about these because it is designed to model taint, and
 * in taint rules terms these are not needed, as the connection between construction, appends and the
 * eventual `toString` is more obvious.
 */
private class StringBuilderVarExt extends StringBuilderVar {
  /**
   * Returns a first assignment after this StringBuilderVar is first assigned.
   *
   * For example, for `StringBuilder sbv = new StringBuilder("1").append("2"); sbv.append("3").append("4");`
   * this returns the append of `"3"`.
   */
  private StringBuilderAppend getAFirstAppendAfterAssignment() {
    result = this.getAnAppend() and not result = this.getNextAppend(_)
  }

  /**
   * Gets the next `append` after `prev`, where `prev` is, perhaps after some more `append` or other
   * chained calls, assigned to this `StringBuilderVar`.
   */
  private StringBuilderAppend getNextAssignmentChainedAppend(StringBuilderConstructorOrAppend prev) {
    getQualifier*(result) = this.getAnAssignedValue() and
    result.getQualifier() = prev
  }

  /**
   * Get a constructor call or `append` call that contributes a string to this string builder.
   */
  StringBuilderConstructorOrAppend getAConstructorOrAppend() {
    exists(this.getNextAssignmentChainedAppend(result)) or
    result = this.getAnAssignedValue() or
    result = this.getAnAppend()
  }

  /**
   * Like `StringBuilderVar.getNextAppend`, except including appends and constructors directly
   * assigned to this `StringBuilderVar`.
   */
  private StringBuilderAppend getNextAppendIncludingAssignmentChains(
    StringBuilderConstructorOrAppend prev
  ) {
    result = this.getNextAssignmentChainedAppend(prev)
    or
    prev = this.getAnAssignedValue() and
    result = this.getAFirstAppendAfterAssignment()
    or
    result = this.getNextAppend(prev)
  }

  /**
   * Implements `StringBuilderVarExt.getNextAppendIncludingAssignmentChains+(prev)`.
   */
  pragma[nomagic]
  StringBuilderAppend getSubsequentAppendIncludingAssignmentChains(
    StringBuilderConstructorOrAppend prev
  ) {
    result = this.getNextAppendIncludingAssignmentChains(prev) or
    result =
      this.getSubsequentAppendIncludingAssignmentChains(this.getNextAppendIncludingAssignmentChains(prev))
  }
}

/**
 * Holds if `follows` may be concatenated after `prefix`.
 */
private predicate mayFollowInterestingPrefix(InterestingPrefix prefix, Expr follows) {
  // Expressions that come after an interesting prefix in a tree of string additions:
  follows =
    any(AddExpr add | add.getLeftOperand() = getAnInterestingPrefix(prefix)).getRightOperand()
  or
  // Sanitize expressions that come after an interesting prefix in a sequence of StringBuilder operations:
  exists(
    StringBuilderConstructorOrAppend appendSanitizingConstant, StringBuilderAppend subsequentAppend,
    StringBuilderVarExt v
  |
    appendSanitizingConstant = v.getAConstructorOrAppend() and
    appendSanitizingConstant.getArgument(0) = getAnInterestingPrefix(prefix) and
    v.getSubsequentAppendIncludingAssignmentChains(appendSanitizingConstant) = subsequentAppend and
    follows = subsequentAppend.getArgument(0)
  )
  or
  // Sanitize expressions that come after an interesting prefix in the args to a format call:
  exists(
    FormattingCall formatCall, FormatString formatString, int prefixOffset, int laterOffset,
    int sanitizedArg
  |
    formatString = unique(FormatString fs | fs = formatCall.getAFormatString()) and
    (
      // An interesting prefix argument comes before this:
      exists(int argIdx |
        formatCall.getArgumentToBeFormatted(argIdx) = prefix and
        prefixOffset = formatString.getAnArgUsageOffset(argIdx)
      )
      or
      // The format string itself contains an interesting prefix that precedes subsequent arguments:
      formatString = prefix.getStringValue() and
      prefixOffset = prefix.getOffset()
    ) and
    laterOffset > prefixOffset and
    laterOffset = formatString.getAnArgUsageOffset(sanitizedArg) and
    follows = formatCall.getArgumentToBeFormatted(sanitizedArg)
  )
}
