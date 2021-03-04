import java
import DataFlow
import JsonStringLib
import semmle.code.java.security.XSS
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.spring.SpringController

/** Taint-tracking configuration tracing flow from user-controllable function name jsonp data to output jsonp data. */
class VerificationMethodFlowConfig extends TaintTracking::Configuration {
  VerificationMethodFlowConfig() { this = "VerificationMethodFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma, BarrierGuard bg |
      ma.getMethod().getAParameter().getName().regexpMatch("(?i).*(token|auth|referer|origin).*") and
      bg = ma and
      sink.asExpr() = ma.getAnArgument()
    )
  }
}

/** The parameter name of the method is `token`, `auth`, `referer`, `origin`. */
class VerificationMethodClass extends Method {
  VerificationMethodClass() {
    exists(MethodAccess ma, BarrierGuard bg, VerificationMethodFlowConfig vmfc, Node node |
      this = ma.getMethod() and
      this.getAParameter().getName().regexpMatch("(?i).*(token|auth|referer|origin).*") and
      bg = ma and
      node.asExpr() = ma.getAnArgument() and
      vmfc.hasFlowTo(node)
    )
  }
}

/** Get Callable by recursive method. */
Callable getAnMethod(Callable call) {
  result = call
  or
  result = getAnMethod(call.getAReference().getEnclosingCallable())
}

abstract class RequestGetMethod extends Method { }

/** Holds if `m` is a method of some override of `HttpServlet.doGet`. */
private class ServletGetMethod extends RequestGetMethod {
  ServletGetMethod() {
    exists(Method m |
      m = this and
      isServletRequestMethod(m) and
      m.getName() = "doGet"
    )
  }
}

/** Holds if `m` is a method of some override of `HttpServlet.doGet`. */
private class SpringControllerGetMethod extends RequestGetMethod {
  SpringControllerGetMethod() {
    exists(Annotation a |
      a = this.getAnAnnotation() and
      a.getType().hasQualifiedName("org.springframework.web.bind.annotation", "GetMapping")
    )
    or
    exists(Annotation a |
      a = this.getAnAnnotation() and
      a.getType().hasQualifiedName("org.springframework.web.bind.annotation", "RequestMapping") and
      a.getValue("method").toString().regexpMatch("RequestMethod.GET|\\{...\\}")
    )
  }
}

/** A concatenate expression using `(` and `)` or `);`. */
class JsonpInjectionExpr extends AddExpr {
  JsonpInjectionExpr() {
    getRightOperand().toString().regexpMatch("\"\\)\"|\"\\);\"") and
    getLeftOperand()
        .(AddExpr)
        .getLeftOperand()
        .(AddExpr)
        .getRightOperand()
        .toString()
        .regexpMatch("\"\\(\"")
  }

  /** Get the jsonp function name of this expression */
  Expr getFunctionName() {
    result = getLeftOperand().(AddExpr).getLeftOperand().(AddExpr).getLeftOperand()
  }

  /** Get the json data of this expression */
  Expr getJsonExpr() { result = getLeftOperand().(AddExpr).getRightOperand() }
}

/** A data flow configuration tracing flow from remote sources to jsonp function name. */
class RemoteFlowConfig extends DataFlow2::Configuration {
  RemoteFlowConfig() { this = "RemoteFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(JsonpInjectionExpr jhe | jhe.getFunctionName() = sink.asExpr())
  }
}

/** A data flow configuration tracing flow from json data to splicing jsonp data. */
class JsonDataFlowConfig extends DataFlow2::Configuration {
  JsonDataFlowConfig() { this = "JsonDataFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof JsonpStringSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(JsonpInjectionExpr jhe | jhe.getJsonExpr() = sink.asExpr())
  }
}

/** Taint-tracking configuration tracing flow from user-controllable function name jsonp data to output jsonp data. */
class JsonpInjectionFlowConfig extends TaintTracking::Configuration {
  JsonpInjectionFlowConfig() { this = "JsonpInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node src) {
    exists(JsonpInjectionExpr jhe, JsonDataFlowConfig jdfc, RemoteFlowConfig rfc |
      jhe = src.asExpr() and
      jdfc.hasFlowTo(DataFlow::exprNode(jhe.getJsonExpr())) and
      rfc.hasFlowTo(DataFlow::exprNode(jhe.getFunctionName()))
    )
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof XssSink }
}
