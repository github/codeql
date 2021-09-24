import java
import DataFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.Servlets

/** A sanitizer for unsafe url forward vulnerabilities. */
abstract class UnsafeUrlForwardSanitizer extends DataFlow::Node { }

private class PrimitiveSanitizer extends UnsafeUrlForwardSanitizer {
  PrimitiveSanitizer() {
    this.getType() instanceof PrimitiveType or
    this.getType() instanceof BoxedType or
    this.getType() instanceof NumberType
  }
}

private class UnsafeUrlForwardSantizer extends UnsafeUrlForwardSanitizer {
  UnsafeUrlForwardSantizer() { this.asExpr() instanceof UnsafeUrlForwardSanitizedExpr }
}

private class UnsafeUrlForwardSanitizingConstantPrefix extends CompileTimeConstantExpr {
  UnsafeUrlForwardSanitizingConstantPrefix() {
    not this.getStringValue().matches("/WEB-INF/%") and
    not this.getStringValue() = "forward:"
  }
}

private Expr getAUnsafeUrlForwardSanitizingPrefix() {
  result instanceof UnsafeUrlForwardSanitizingConstantPrefix
  or
  result.(AddExpr).getAnOperand() = getAUnsafeUrlForwardSanitizingPrefix()
}

/** A call to `StringBuilder.append` method. */
class StringBuilderAppend extends MethodAccess {
  StringBuilderAppend() {
    this.getMethod().getDeclaringType() instanceof StringBuildingType and
    this.getMethod().hasName("append")
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

private class StringBuilderConstructorOrAppend extends Call {
  StringBuilderConstructorOrAppend() {
    this instanceof StringBuilderAppend or
    this.(ClassInstanceExpr).getConstructedType() instanceof StringBuildingType
  }
}

private class UnsafeUrlForwardSanitizedExpr extends Expr {
  UnsafeUrlForwardSanitizedExpr() {
    // Sanitize expressions that come after a sanitizing prefix in a tree of string additions:
    this =
      any(AddExpr add | add.getLeftOperand() = getAUnsafeUrlForwardSanitizingPrefix())
          .getRightOperand()
    or
    // Sanitize expressions that come after a sanitizing prefix in a sequence of StringBuilder operations:
    exists(
      StringBuilderConstructorOrAppend appendSanitizingConstant,
      StringBuilderAppend subsequentAppend, StringBuilderVarExt v
    |
      appendSanitizingConstant = v.getAConstructorOrAppend() and
      appendSanitizingConstant.getArgument(0) = getAUnsafeUrlForwardSanitizingPrefix() and
      v.getSubsequentAppendIncludingAssignmentChains(appendSanitizingConstant) = subsequentAppend and
      this = subsequentAppend.getArgument(0)
    )
    or
    exists(MethodAccess ma, int i |
      ma.getMethod().hasName("format") and
      ma.getMethod().getDeclaringType() instanceof TypeString and
      ma.getArgument(0) instanceof UnsafeUrlForwardSanitizingConstantPrefix and
      ma.getArgument(i) = this and
      i != 0
    )
  }
}

/**
 * A concatenate expression using the string `forward:` on the left.
 *
 * E.g: `"forward:" + url`
 */
private class ForwardBuilderExpr extends AddExpr {
  ForwardBuilderExpr() {
    this.getLeftOperand().(CompileTimeConstantExpr).getStringValue() = "forward:"
  }
}

/**
 * A call to `StringBuilder.append` or `StringBuffer.append` method, and the parameter value is `"forward:"`.
 *
 * E.g: `StringBuilder.append("forward:")`
 */
private class ForwardAppendCall extends StringBuilderAppend {
  ForwardAppendCall() {
    this.getArgument(0).(CompileTimeConstantExpr).getStringValue() = "forward:"
  }
}

abstract class UnsafeUrlForwardSink extends DataFlow::Node { }

/** A Unsafe url forward sink from getRequestDispatcher method. */
private class RequestDispatcherSink extends UnsafeUrlForwardSink {
  RequestDispatcherSink() {
    exists(MethodAccess ma |
      ma.getMethod() instanceof ServletRequestGetRequestDispatcherMethod and
      ma.getArgument(0) = this.asExpr()
    )
  }
}

/** A Unsafe url forward sink from spring controller method. */
private class SpringUrlForwardSink extends UnsafeUrlForwardSink {
  SpringUrlForwardSink() {
    exists(ForwardBuilderExpr rbe |
      rbe.getRightOperand() = this.asExpr() and
      any(SpringRequestMappingMethod sqmm).polyCalls*(this.getEnclosingCallable())
    )
    or
    exists(MethodAccess ma, ForwardAppendCall rac |
      DataFlow2::localExprFlow(rac.getQualifier(), ma.getQualifier()) and
      ma.getMethod().hasName("append") and
      ma.getArgument(0) = this.asExpr() and
      any(SpringRequestMappingMethod sqmm).polyCalls*(this.getEnclosingCallable())
    )
    or
    exists(ClassInstanceExpr cie |
      cie.getConstructedType().hasQualifiedName("org.springframework.web.servlet", "ModelAndView") and
      (
        exists(ForwardBuilderExpr rbe |
          rbe = cie.getArgument(0) and rbe.getRightOperand() = this.asExpr()
        )
        or
        cie.getArgument(0) = this.asExpr()
      )
    )
    or
    exists(MethodAccess ma |
      ma.getMethod().hasName("setViewName") and
      ma.getMethod()
          .getDeclaringType()
          .hasQualifiedName("org.springframework.web.servlet", "ModelAndView") and
      ma.getArgument(0) = this.asExpr()
    )
  }
}
