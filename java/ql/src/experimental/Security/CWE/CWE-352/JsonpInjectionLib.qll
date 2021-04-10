import java
import DataFlow
import JsonStringLib
import semmle.code.java.security.XSS
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.DataFlow3
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.spring.SpringController

/** A data flow configuration tracing flow from the result of a method whose name includes token/auth/referer/origin to an if-statement condition. */
class VerificationMethodToIfFlowConfig extends DataFlow3::Configuration {
  VerificationMethodToIfFlowConfig() { this = "VerificationMethodToIfFlowConfig" }

  override predicate isSource(DataFlow::Node src) {
    exists(MethodAccess ma | ma instanceof BarrierGuard |
      (
        ma.getMethod().getAParameter().getName().regexpMatch("(?i).*(token|auth|referer|origin).*")
        or
        ma.getMethod().getName().regexpMatch("(?i).*(token|auth|referer|origin).*")
      ) and
      ma = src.asExpr()
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(IfStmt is | is.getCondition() = sink.asExpr())
  }
}

/** Taint-tracking configuration tracing flow from untrusted inputs to an argument of a function whose result is used as an if-statement condition.
* 
* For example, in the context `String userControlled = request.getHeader("xyz"); boolean isGood = checkToken(userControlled); if(isGood) { ...`,
* the flow from `checkToken`'s result to the condition of `if(isGood)` matches the configuration `VerificationMethodToIfFlowConfig` above,
* and so the flow from `getHeader(...)` to the argument to `checkToken` matches this configuration.
 */
class VerificationMethodFlowConfig extends TaintTracking2::Configuration {
  VerificationMethodFlowConfig() { this = "VerificationMethodFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma, int i, VerificationMethodToIfFlowConfig vmtifc |
      ma instanceof BarrierGuard
    |
      (
        ma.getMethod().getParameter(i).getName().regexpMatch("(?i).*(token|auth|referer|origin).*")
        or
        ma.getMethod().getName().regexpMatch("(?i).*(token|auth|referer|origin).*")
      ) and
      ma.getArgument(i) = sink.asExpr() and
      vmtifc.hasFlow(exprNode(ma), _)
    )
  }
}

/** Get Callable by recursive method. */
Callable getACallingCallableOrSelf(Callable call) {
  result = call
  or
  result = getACallingCallableOrSelf(call.getAReference().getEnclosingCallable())
}

/**
 * A method that is called to handle an HTTP GET request.
 */
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
class JsonpBuilderExpr extends AddExpr {
  JsonpInjectionExpr() {
    getRightOperand().toString().regexpMatch("\"\\);?\"") and
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

/** A data flow configuration tracing flow from json data into the argument `json` of JSONP-like string `someFunctionName + "(" + json + ")"`. */
class JsonDataFlowConfig extends DataFlow2::Configuration {
  JsonDataFlowConfig() { this = "JsonDataFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof JsonpStringSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(JsonpInjectionExpr jhe | jhe.getJsonExpr() = sink.asExpr())
  }
}

/** Taint-tracking configuration tracing flow from probable jsonp data with a user-controlled function name to an outgoing HTTP entity. */
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
