import java
import DataFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.Servlets

/**
 * A concatenate expression using the string `forward:` on the left.
 *
 * E.g: `"forward:" + url`
 */
class ForwardBuilderExpr extends AddExpr {
  ForwardBuilderExpr() {
    this.getLeftOperand().(CompileTimeConstantExpr).getStringValue() = "forward:"
  }
}

/**
 * A call to `StringBuilder.append` or `StringBuffer.append` method, and the parameter value is `"forward:"`.
 *
 * E.g: `StringBuilder.append("forward:")`
 */
class ForwardAppendCall extends MethodAccess {
  ForwardAppendCall() {
    this.getMethod().hasName("append") and
    this.getMethod().getDeclaringType() instanceof StringBuildingType and
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
