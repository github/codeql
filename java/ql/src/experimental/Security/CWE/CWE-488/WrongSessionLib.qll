import java
import DataFlow
import semmle.code.java.UnitTests
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking2
import semmle.code.java.frameworks.Servlets
import semmle.code.java.frameworks.struts.StrutsActions
import semmle.code.java.frameworks.spring.SpringController

/** Taint-tracking configuration tracing flow from remote input source to do a blank check on remote input. */
class InputJudgeConfig extends TaintTracking2::Configuration {
  InputJudgeConfig() { this = "InputJudgeConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource and
    not hasDefaultValue(source) and
    source.getEnclosingCallable() instanceof RequestMethod
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma, BarrierGuard bg | ma = bg |
      ma.getMethod().getName() = ["isNullOrEmpty", "isEmpty"] and
      ma.getMethod().getNumberOfParameters() = 1 and
      ma.getArgument(0) = sink.asExpr() and
      exists(WrongSessionSink ws | bg.controls(ws.getExpr().getBasicBlock(), false))
    )
    or
    exists(MethodAccess ma, BarrierGuard bg | ma = bg |
      ma.getMethod().hasName("isNotEmpty") and
      ma.getMethod().getNumberOfParameters() = 1 and
      ma.getArgument(0) = sink.asExpr() and
      exists(WrongSessionSink ws | bg.controls(ws.getExpr().getBasicBlock(), true))
    )
    or
    exists(NEExpr nee, IfStmt is, BarrierGuard bg | nee = bg and is.getCondition() = nee |
      (
        nee.getRightOperand() instanceof Literal and
        nee.getLeftOperand() = sink.asExpr()
        or
        nee.getLeftOperand() instanceof Literal and
        nee.getRightOperand() = sink.asExpr()
      ) and
      exists(WrongSessionSink ws | bg.controls(ws.getExpr().getBasicBlock(), true))
    )
  }
}

/** A sink that assigning remote input to a non `final` field variable. */
class WrongSessionSink extends DataFlow::ExprNode {
  WrongSessionSink() {
    exists(AssignExpr ae, FieldAccess fa, IfStmt is, ExprStmt es | ae.getParent() = es |
      not exists(is.getElse()) and
      es.getParent*() = is.getAChild() and
      not fa.getField().isFinal() and
      ae.getDest() = fa and
      ae.getRhs() = this.asExpr()
    )
  }
}

/** Determine whether the source is set to the default value. */
predicate hasDefaultValue(Node node) {
  exists(SpringControllerMethod scm |
    node.asParameter() = scm.getAParameter() and
    node.asParameter().hasAnnotation("org.springframework.web.bind.annotation", "RequestParam") and
    node.asParameter().getAnAnnotation().getValue("defaultValue").toString() !=
      "\"\\n\\t\\t\\n\\t\\t\\n\\n\\t\\t\\t\\t\\n\"" //The default value of defaultValue annotation is "\\n\\t\\t\\n\\t\\t\\n\\n\\t\\t\\t\\t\\n"
  )
}

/** The request method in `Servlet` or `SpringController`. */
class RequestMethod extends Method {
  RequestMethod() {
    (
      this instanceof ServletRequestMethod
      or
      this instanceof SpringControllerMethod
    ) and
    not this instanceof TestMethod and
    not this.getName().regexpMatch("(?!).*test.*") and
    not exists(this.getLocation().getFile().getAbsolutePath().indexOf("/src/test/java"))
  }
}
