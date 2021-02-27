import java
import DataFlow
import JsonStringLib
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.spring.SpringController

/** Holds if `m` is a method of some override of `HttpServlet.doGet`. */
private predicate isGetServletMethod(Method m) {
  isServletRequestMethod(m) and m.getName() = "doGet"
}

/** Holds if `m` is a method of some override of `HttpServlet.doGet`. */
private predicate isGetSpringControllerMethod(Method m) {
  exists(Annotation a |
    a = m.getAnAnnotation() and
    a.getType().hasQualifiedName("org.springframework.web.bind.annotation", "GetMapping")
  )
  or
  exists(Annotation a |
    a = m.getAnAnnotation() and
    a.getType().hasQualifiedName("org.springframework.web.bind.annotation", "RequestMapping") and
    a.getValue("method").toString().regexpMatch("RequestMethod.GET|\\{...\\}")
  )
}

/** Method parameters use the annotation `@RequestParam` or the parameter type is `ServletRequest`, `String`, `Object` */
predicate checkSpringMethodParameterType(Method m, int i) {
  m.getParameter(i).getType() instanceof ServletRequest
  or
  exists(Parameter p |
    p = m.getParameter(i) and
    p.hasAnnotation() and
    p.getAnAnnotation()
        .getType()
        .hasQualifiedName("org.springframework.web.bind.annotation", "RequestParam") and
    p.getType().getName().regexpMatch("String|Object")
  )
  or
  exists(Parameter p |
    p = m.getParameter(i) and
    not p.hasAnnotation() and
    p.getType().getName().regexpMatch("String|Object")
  )
}

/** A data flow source for get method request parameters. */
abstract class GetHttpRequestSource extends DataFlow::Node { }

/** A data flow source for servlet get method request parameters. */
private class ServletGetHttpRequestSource extends GetHttpRequestSource {
  ServletGetHttpRequestSource() {
    exists(Method m |
      isGetServletMethod(m) and
      m.getParameter(0).getAnAccess() = this.asExpr()
    )
  }
}

/** A data flow source for spring controller get method request parameters. */
private class SpringGetHttpRequestSource extends GetHttpRequestSource {
  SpringGetHttpRequestSource() {
    exists(SpringControllerMethod scm, int i |
      isGetSpringControllerMethod(scm) and
      checkSpringMethodParameterType(scm, i) and
      scm.getParameter(i).getAnAccess() = this.asExpr()
    )
  }
}

/** A data flow sink for unvalidated user input that is used to jsonp. */
abstract class JsonpInjectionSink extends DataFlow::Node { }

/** Use ```print```, ```println```, ```write``` to output result. */
private class WriterPrintln extends JsonpInjectionSink {
  WriterPrintln() {
    exists(MethodAccess ma |
      ma.getMethod().getName().regexpMatch("print|println|write") and
      ma.getMethod()
          .getDeclaringType()
          .getASourceSupertype*()
          .hasQualifiedName("java.io", "PrintWriter") and
      ma.getArgument(0) = this.asExpr()
    )
  }
}

/** Spring Request Method return result. */
private class SpringReturn extends JsonpInjectionSink {
  SpringReturn() {
    exists(ReturnStmt rs, Method m | m = rs.getEnclosingCallable() |
      isGetSpringControllerMethod(m) and
      rs.getResult() = this.asExpr()
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
class JsonpInjectionFlowConfig extends DataFlow::Configuration {
  JsonpInjectionFlowConfig() { this = "JsonpInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node src) {
    exists(JsonpInjectionExpr jhe, JsonDataFlowConfig jdfc, RemoteFlowConfig rfc |
      jhe = src.asExpr() and
      jdfc.hasFlowTo(DataFlow::exprNode(jhe.getJsonExpr())) and
      rfc.hasFlowTo(DataFlow::exprNode(jhe.getFunctionName()))
    )
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof JsonpInjectionSink }
}
