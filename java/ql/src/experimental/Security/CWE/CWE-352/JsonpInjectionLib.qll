import java
import DataFlow
import JsonStringLib
import semmle.code.java.security.XSS
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.spring.SpringController

/** Taint-tracking configuration tracing flow from untrusted inputs to verification of remote user input. */
class VerificationMethodFlowConfig extends TaintTracking::Configuration {
  VerificationMethodFlowConfig() { this = "VerificationMethodFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod().getAParameter().getName().regexpMatch("(?i).*(token|auth|referer|origin).*") and
      ma.getAnArgument() = sink.asExpr()
    )
  }
}

/** The parameter names of this method are token/auth/referer/origin. */
class VerificationMethodClass extends Method {
  VerificationMethodClass() {
    exists(MethodAccess ma, VerificationMethodFlowConfig vmfc, Node node |
      this = ma.getMethod() and
      node.asExpr() = ma.getAnArgument() and
      vmfc.hasFlowTo(node)
    )
  }
}

/** Get Callable by recursive method. */
Callable getACallingCallableOrSelf(Callable call) {
  result = call
  or
  result = getACallingCallableOrSelf(call.getAReference().getEnclosingCallable())
}

abstract class RequestGetMethod extends Method { }

/** Override method of `doGet` of `Servlet` subclass. */
private class ServletGetMethod extends RequestGetMethod {
  ServletGetMethod() { this instanceof DoGetServletMethod }
}

/** The method of SpringController class processing `get` request. */
abstract class SpringControllerGetMethod extends RequestGetMethod { }

/** Method using `GetMapping` annotation in SpringController class. */
class SpringControllerGetMappingGetMethod extends SpringControllerGetMethod {
  SpringControllerGetMappingGetMethod() {
    this.getAnAnnotation()
        .getType()
        .hasQualifiedName("org.springframework.web.bind.annotation", "GetMapping")
  }
}

/** The method that uses the `RequestMapping` annotation in the SpringController class and only handles the get request. */
class SpringControllerRequestMappingGetMethod extends SpringControllerGetMethod {
  SpringControllerRequestMappingGetMethod() {
    this.getAnAnnotation()
        .getType()
        .hasQualifiedName("org.springframework.web.bind.annotation", "RequestMapping") and
    this.getAnAnnotation().getValue("method").toString().regexpMatch("RequestMethod.GET|\\{...\\}") and
    not exists(MethodAccess ma |
      ma.getMethod() instanceof ServletRequestGetBodyMethod and
      this = getACallingCallableOrSelf(ma.getEnclosingCallable())
    ) and
    not this.getAParamType().getName() = "MultipartFile"
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

  /** Get the jsonp function name of this expression. */
  Expr getFunctionName() {
    result = getLeftOperand().(AddExpr).getLeftOperand().(AddExpr).getLeftOperand()
  }

  /** Get the json data of this expression. */
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
