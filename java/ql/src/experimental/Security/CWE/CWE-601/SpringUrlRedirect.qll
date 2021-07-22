import java
import DataFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.DataFlow2
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.frameworks.spring.SpringController

/**
 * A concatenate expression using the string `redirect:` or `ajaxredirect:` or `forward:` on the left.
 *
 * E.g: `"redirect:" + redirectUrl`
 */
class RedirectBuilderExpr extends AddExpr {
  RedirectBuilderExpr() {
    this.getLeftOperand().(CompileTimeConstantExpr).getStringValue() in [
        "redirect:", "ajaxredirect:", "forward:"
      ]
  }
}

/**
 * A call to `StringBuilder.append` or `StringBuffer.append` method, and the parameter value is
 * `"redirect:"` or `"ajaxredirect:"` or `"forward:"`.
 *
 * E.g: `StringBuilder.append("redirect:")`
 */
class RedirectAppendCall extends MethodAccess {
  RedirectAppendCall() {
    this.getMethod().hasName("append") and
    this.getMethod().getDeclaringType() instanceof StringBuildingType and
    this.getArgument(0).(CompileTimeConstantExpr).getStringValue() in [
        "redirect:", "ajaxredirect:", "forward:"
      ]
  }
}

/** A URL redirection sink from spring controller method. */
class SpringUrlRedirectSink extends DataFlow::Node {
  SpringUrlRedirectSink() {
    exists(RedirectBuilderExpr rbe |
      rbe.getRightOperand() = this.asExpr() and
      any(SpringRequestMappingMethod sqmm).polyCalls*(this.getEnclosingCallable())
    )
    or
    exists(MethodAccess ma, RedirectAppendCall rac |
      DataFlow2::localExprFlow(rac.getQualifier(), ma.getQualifier()) and
      ma.getMethod().hasName("append") and
      ma.getArgument(0) = this.asExpr() and
      any(SpringRequestMappingMethod sqmm).polyCalls*(this.getEnclosingCallable())
    )
    or
    exists(MethodAccess ma |
      ma.getMethod().hasName("setUrl") and
      ma.getMethod()
          .getDeclaringType()
          .hasQualifiedName("org.springframework.web.servlet.view", "AbstractUrlBasedView") and
      ma.getArgument(0) = this.asExpr()
    )
    or
    exists(ClassInstanceExpr cie |
      cie.getConstructedType()
          .hasQualifiedName("org.springframework.web.servlet.view", "RedirectView") and
      cie.getArgument(0) = this.asExpr()
    )
    or
    exists(ClassInstanceExpr cie |
      cie.getConstructedType().hasQualifiedName("org.springframework.web.servlet", "ModelAndView") and
      exists(RedirectBuilderExpr rbe |
        rbe = cie.getArgument(0) and rbe.getRightOperand() = this.asExpr()
      )
    )
  }
}
