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
      exists(RedirectBuilderFlowConfig rbfc | rbfc.hasFlow(exprNode(rbe), _))
    )
    or
    exists(MethodAccess ma, RedirectAppendCall rac |
      DataFlow2::localExprFlow(rac.getQualifier(), ma.getQualifier()) and
      ma.getMethod().hasName("append") and
      ma.getArgument(0) = this.asExpr() and
      exists(RedirectBuilderFlowConfig rbfc | rbfc.hasFlow(exprNode(ma.getQualifier()), _))
    )
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
      exists(RedirectBuilderExpr rbe |
        rbe = cie.getArgument(0) and rbe.getRightOperand() = this.asExpr()
      )
    )
  }
}

/** A data flow configuration tracing flow from redirect builder expression to spring controller method return expression. */
private class RedirectBuilderFlowConfig extends DataFlow2::Configuration {
  RedirectBuilderFlowConfig() { this = "RedirectBuilderFlowConfig" }

  override predicate isSource(DataFlow::Node src) {
    exists(RedirectBuilderExpr rbe | rbe = src.asExpr())
    or
    exists(MethodAccess ma, RedirectAppendCall rac |
      DataFlow2::localExprFlow(rac.getQualifier(), ma.getQualifier()) and
      ma.getMethod().hasName("append") and
      ma.getQualifier() = src.asExpr()
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(ReturnStmt rs, SpringRequestMappingMethod sqmm |
      rs.getResult() = sink.asExpr() and
      sqmm.getBody().getAStmt() = rs
    )
  }

  override predicate isAdditionalFlowStep(Node prod, Node succ) {
    exists(MethodAccess ma |
      ma.getMethod().hasName("toString") and
      ma.getMethod().getDeclaringType() instanceof StringBuildingType and
      ma.getQualifier() = prod.asExpr() and
      ma = succ.asExpr()
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
