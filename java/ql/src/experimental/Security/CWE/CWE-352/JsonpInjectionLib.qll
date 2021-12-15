import java
import DataFlow
import JsonStringLib
import semmle.code.java.security.XSS
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.DataFlow3
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.spring.SpringController

/**
 * A method that is called to handle an HTTP GET request.
 */
abstract class RequestGetMethod extends Method {
  RequestGetMethod() {
    not exists(MethodAccess ma |
      // Exclude apparent GET handlers that read a request entity, because this likely indicates this is not in fact a GET handler.
      // This is particularly a problem with Spring handlers, which can sometimes neglect to specify a request method.
      // Even if it is in fact a GET handler, such a request method will be unusable in the context `<script src="...">`,
      // which is the typical use-case for JSONP but cannot supply a request body.
      ma.getMethod() instanceof ServletRequestGetBodyMethod and
      this.polyCalls*(ma.getEnclosingCallable())
    )
  }
}

/** Override method of `doGet` of `Servlet` subclass. */
private class ServletGetMethod extends RequestGetMethod {
  ServletGetMethod() { isServletRequestMethod(this) and this.getName() = "doGet" }
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
    (
      this.getAnAnnotation().getValue("method").(VarAccess).getVariable().getName() = "GET" or
      this.getAnAnnotation().getValue("method").(ArrayInit).getSize() = 0 //Java code example: @RequestMapping(value = "test")
    ) and
    not this.getAParamType().getName() = "MultipartFile"
  }
}

/**
 * A concatenate expression using `(` and `)` or `);`.
 *
 * E.g: `functionName + "(" + json + ")"` or `functionName + "(" + json + ");"`
 */
class JsonpBuilderExpr extends AddExpr {
  JsonpBuilderExpr() {
    this.getRightOperand().(CompileTimeConstantExpr).getStringValue().regexpMatch("\\);?") and
    this.getLeftOperand()
        .(AddExpr)
        .getLeftOperand()
        .(AddExpr)
        .getRightOperand()
        .(CompileTimeConstantExpr)
        .getStringValue() = "("
  }

  /** Get the jsonp function name of this expression. */
  Expr getFunctionName() {
    result = this.getLeftOperand().(AddExpr).getLeftOperand().(AddExpr).getLeftOperand()
  }

  /** Get the json data of this expression. */
  Expr getJsonExpr() { result = this.getLeftOperand().(AddExpr).getRightOperand() }
}

/** A data flow configuration tracing flow from remote sources to jsonp function name. */
class RemoteFlowConfig extends DataFlow2::Configuration {
  RemoteFlowConfig() { this = "RemoteFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(JsonpBuilderExpr jhe | jhe.getFunctionName() = sink.asExpr())
  }
}

/** A data flow configuration tracing flow from json data into the argument `json` of JSONP-like string `someFunctionName + "(" + json + ")"`. */
class JsonDataFlowConfig extends DataFlow2::Configuration {
  JsonDataFlowConfig() { this = "JsonDataFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof JsonStringSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(JsonpBuilderExpr jhe | jhe.getJsonExpr() = sink.asExpr())
  }
}

/** Taint-tracking configuration tracing flow from probable jsonp data with a user-controlled function name to an outgoing HTTP entity. */
class JsonpInjectionFlowConfig extends TaintTracking::Configuration {
  JsonpInjectionFlowConfig() { this = "JsonpInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node src) {
    exists(JsonpBuilderExpr jhe, JsonDataFlowConfig jdfc, RemoteFlowConfig rfc |
      jhe = src.asExpr() and
      jdfc.hasFlowTo(DataFlow::exprNode(jhe.getJsonExpr())) and
      rfc.hasFlowTo(DataFlow::exprNode(jhe.getFunctionName()))
    )
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof XssSink }
}
