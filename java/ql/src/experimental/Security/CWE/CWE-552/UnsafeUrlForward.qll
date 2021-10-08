import java
import DataFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.Servlets
import semmle.code.java.frameworks.spring.SpringWeb
import semmle.code.java.security.RequestForgery

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
 * For example, `"forward:" + url`.
 */
private class ForwardBuilderExpr extends AddExpr {
  ForwardBuilderExpr() {
    this.getLeftOperand().(CompileTimeConstantExpr).getStringValue() = "forward:"
  }
}

/**
 * A call to `StringBuilder.append` or `StringBuffer.append` method, and the parameter value is `"forward:"`.
 *
 * For example, `StringBuilder.append("forward:")`.
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
      cie.getConstructedType() instanceof ModelAndView and
      (
        exists(ForwardBuilderExpr rbe |
          rbe = cie.getArgument(0) and rbe.getRightOperand() = this.asExpr()
        )
        or
        cie.getArgument(0) = this.asExpr()
      )
    )
    or
    exists(SpringModelAndViewSetViewNameCall smavsvnc | smavsvnc.getArgument(0) = this.asExpr())
  }
}
