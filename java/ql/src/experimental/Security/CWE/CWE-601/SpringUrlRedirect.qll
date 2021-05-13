import java
import DataFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.DataFlow2
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.frameworks.spring.SpringController

class StartsWithSanitizer extends DataFlow::BarrierGuard {
  StartsWithSanitizer() {
    this.(MethodAccess).getMethod().hasName("startsWith") and
    this.(MethodAccess).getMethod().getDeclaringType() instanceof TypeString and
    this.(MethodAccess).getMethod().getNumberOfParameters() = 1
  }

  override predicate checks(Expr e, boolean branch) {
    e = this.(MethodAccess).getQualifier() and branch = true
  }
}

/**
 * A concatenate expression using the string `redirect:` on the left.
 *
 * E.g: `"redirect:" + redirectUrl`
 */
class RedirectBuilderExpr extends AddExpr {
  RedirectBuilderExpr() {
    this.getLeftOperand().(CompileTimeConstantExpr).getStringValue() = "redirect:"
  }
}

/** A URL redirection sink from spring controller method. */
class SpringUrlRedirectSink extends DataFlow::Node {
  SpringUrlRedirectSink() {
    exists(RedirectBuilderExpr rbe | rbe.getRightOperand() = this.asExpr())
    or
    exists(MethodAccess ma |
      ma.getMethod().hasName("setUrl") and
      ma.getMethod()
          .getDeclaringType()
          .hasQualifiedName("org.springframework.web.servlet.view", "AbstractUrlBasedView") and
      ma.getArgument(0) = this.asExpr() and
      exists(RedirectViewFlowConfig rvfc | rvfc.hasFlowToExpr(ma.getQualifier()))
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
      cie.getArgument(0) = this.asExpr() and
      exists(RedirectBuilderExpr rbe | rbe.getRightOperand() = this.asExpr())
    )
  }
}

/** A data flow configuration tracing flow from RedirectView object to calling setUrl method. */
private class RedirectViewFlowConfig extends DataFlow2::Configuration {
  RedirectViewFlowConfig() { this = "RedirectViewFlowConfig" }

  override predicate isSource(DataFlow::Node src) {
    exists(ClassInstanceExpr cie |
      cie.getConstructedType()
          .hasQualifiedName("org.springframework.web.servlet.view", "RedirectView") and
      cie = src.asExpr()
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod().hasName("setUrl") and
      ma.getMethod()
          .getDeclaringType()
          .hasQualifiedName("org.springframework.web.servlet.view", "AbstractUrlBasedView") and
      ma.getQualifier() = sink.asExpr()
    )
  }
}
