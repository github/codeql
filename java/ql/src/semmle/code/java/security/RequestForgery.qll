/** Provides classes to reason about server-side request forgery (SSRF) attacks. */

import java
import semmle.code.java.frameworks.Networking
import semmle.code.java.frameworks.ApacheHttp
import semmle.code.java.frameworks.spring.Spring
import semmle.code.java.frameworks.JaxWS
import semmle.code.java.frameworks.javase.Http
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.StringFormat
private import semmle.code.java.dataflow.ExternalFlow

/**
 * A unit class for adding additional taint steps that are specific to server-side request forgery (SSRF) attacks.
 *
 * Extend this class to add additional taint steps to the SSRF query.
 */
class RequestForgeryAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `pred` to `succ` should be considered a taint
   * step for server-side request forgery.
   */
  abstract predicate propagatesTaint(DataFlow::Node pred, DataFlow::Node succ);
}

private class DefaultRequestForgeryAdditionalTaintStep extends RequestForgeryAdditionalTaintStep {
  override predicate propagatesTaint(DataFlow::Node pred, DataFlow::Node succ) {
    // propagate to a URI when its host is assigned to
    exists(UriCreation c | c.getHostArg() = pred.asExpr() | succ.asExpr() = c)
    or
    // propagate to a URL when its host is assigned to
    exists(UrlConstructorCall c | c.getHostArg() = pred.asExpr() | succ.asExpr() = c)
  }
}

/** A data flow sink for server-side request forgery (SSRF) vulnerabilities. */
abstract class RequestForgerySink extends DataFlow::Node { }

private class UrlOpenSinkAsRequestForgerySink extends RequestForgerySink {
  UrlOpenSinkAsRequestForgerySink() { sinkNode(this, "open-url") }
}

/** A sanitizer for request forgery vulnerabilities. */
abstract class RequestForgerySanitizer extends DataFlow::Node { }

private class PrimitiveSanitizer extends RequestForgerySanitizer {
  PrimitiveSanitizer() {
    this.getType() instanceof PrimitiveType or
    this.getType() instanceof BoxedType or
    this.getType() instanceof NumberType
  }
}

private class HostnameSanitizingConstantPrefix extends CompileTimeConstantExpr {
  int offset;

  HostnameSanitizingConstantPrefix() {
    // Matches strings that look like when prepended to untrusted input, they will restrict
    // the host or entity addressed: for example, anything containing `?` or `#`, or a slash that
    // doesn't appear to be a protocol specifier (e.g. `http://` is not sanitizing), or specifically
    // the string "/".
    exists(
      this.getStringValue()
          .regexpFind(".*([?#]|[^?#:/\\\\][/\\\\]).*|[/\\\\][^/\\\\].*|^/$", 0, offset)
    )
  }

  /**
   * Gets the offset in this constant string where a sanitizing substring begins.
   */
  int getOffset() { result = offset }
}

private Expr getAHostnameSanitizingPrefix() {
  result instanceof HostnameSanitizingConstantPrefix
  or
  result.(AddExpr).getAnOperand() = getAHostnameSanitizingPrefix()
}

private class StringBuilderAppend extends MethodAccess {
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

private Expr getQualifier(Expr e) { result = e.(MethodAccess).getQualifier() }

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
    result = getNextAssignmentChainedAppend(prev)
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
 * An expression that is sanitized because it is concatenated onto a string that looks like
 * a hostname or a URL separator, preventing the appended string from arbitrarily controlling
 * the addressed server.
 */
private class HostnameSanitizedExpr extends Expr {
  HostnameSanitizedExpr() {
    // Sanitize expressions that come after a sanitizing prefix in a tree of string additions:
    this =
      any(AddExpr add | add.getLeftOperand() = getAHostnameSanitizingPrefix()).getRightOperand()
    or
    // Sanitize expressions that come after a sanitizing prefix in a sequence of StringBuilder operations:
    exists(
      StringBuilderConstructorOrAppend appendSanitizingConstant,
      StringBuilderAppend subsequentAppend, StringBuilderVarExt v
    |
      appendSanitizingConstant = v.getAConstructorOrAppend() and
      appendSanitizingConstant.getArgument(0) = getAHostnameSanitizingPrefix() and
      v.getSubsequentAppendIncludingAssignmentChains(appendSanitizingConstant) = subsequentAppend and
      this = subsequentAppend.getArgument(0)
    )
    or
    // Sanitize expressions that come after a sanitizing prefix in the args to a format call:
    exists(
      FormattingCall formatCall, FormatString formatString, HostnameSanitizingConstantPrefix prefix,
      int sanitizedFromOffset, int laterOffset, int sanitizedArg
    |
      formatString = unique(FormatString fs | fs = formatCall.getAFormatString()) and
      (
        // A sanitizing argument comes before this:
        exists(int argIdx |
          formatCall.getArgumentToBeFormatted(argIdx) = prefix and
          sanitizedFromOffset = formatString.getAnArgUsageOffset(argIdx)
        )
        or
        // The format string itself sanitizes subsequent arguments:
        formatString = prefix.getStringValue() and
        sanitizedFromOffset = prefix.getOffset()
      ) and
      laterOffset > sanitizedFromOffset and
      laterOffset = formatString.getAnArgUsageOffset(sanitizedArg) and
      this = formatCall.getArgumentToBeFormatted(sanitizedArg)
    )
  }
}

/**
 * A value that is the result of prepending a string that prevents any value from controlling the
 * host of a URL.
 */
private class HostnameSantizer extends RequestForgerySanitizer {
  HostnameSantizer() { this.asExpr() instanceof HostnameSanitizedExpr }
}
