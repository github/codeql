import java
import semmle.code.java.frameworks.Servlets
import semmle.code.java.frameworks.android.WebView
import semmle.code.java.frameworks.spring.SpringController
import semmle.code.java.frameworks.spring.SpringHttp
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking2

/*
 * Definitions for XSS sinks
 */

abstract class XssSink extends DataFlow::Node { }

private class DefaultXssSink extends XssSink {
  DefaultXssSink() {
    exists(HttpServletResponseSendErrorMethod m, MethodAccess ma |
      ma.getMethod() = m and
      this.asExpr() = ma.getArgument(1)
    )
    or
    exists(ServletWriterSourceToWritingMethodFlowConfig writer, MethodAccess ma |
      ma.getMethod() instanceof WritingMethod and
      writer.hasFlowToExpr(ma.getQualifier()) and
      this.asExpr() = ma.getArgument(_)
    )
    or
    exists(Method m |
      m.getDeclaringType() instanceof TypeWebView and
      (
        m.getAReference().getArgument(0) = this.asExpr() and m.getName() = "loadData"
        or
        m.getAReference().getArgument(0) = this.asExpr() and m.getName() = "loadUrl"
        or
        m.getAReference().getArgument(1) = this.asExpr() and m.getName() = "loadDataWithBaseURL"
      )
    )
    or
    exists(SpringRequestMappingMethod requestMappingMethod, ReturnStmt rs |
      requestMappingMethod = rs.getEnclosingCallable() and
      this.asExpr() = rs.getResult() and
      (
        not exists(requestMappingMethod.getProduces()) or
        requestMappingMethod.getProduces().matches("text/%")
      )
    |
      // If a Spring request mapping method is either annotated with @ResponseBody (or equivalent),
      // or returns a HttpEntity or sub-type, then the return value of the method is converted into
      // a HTTP reponse using a HttpMessageConverter implementation. The implementation is chosen
      // based on the return type of the method, and the Accept header of the request.
      //
      // By default, the only message converter which produces a response which is vulnerable to
      // XSS is the StringHttpMessageConverter, which "Accept"s all text/* content types, including
      // text/html. Therefore, if a browser request includes "text/html" in the "Accept" header,
      // any String returned will be converted into a text/html response.
      requestMappingMethod.isResponseBody() and
      requestMappingMethod.getReturnType() instanceof TypeString
      or
      exists(Type returnType |
        // A return type of HttpEntity<T> or ResponseEntity<T> represents an HTTP response with both
        // a body and a set of headers. The body is subject to the same HttpMessageConverter
        // process as above.
        returnType = requestMappingMethod.getReturnType() and
        (
          returnType instanceof SpringHttpEntity
          or
          returnType instanceof SpringResponseEntity
        )
      |
        // The type argument, representing the type of the body, is type String
        returnType.(ParameterizedClass).getTypeArgument(0) instanceof TypeString
        or
        // Return type is a Raw class, which means no static type information on the body. In this
        // case we will still treat this as an XSS sink, but rely on our taint flow steps for
        // HttpEntity/ResponseEntity to only pass taint into those instances if the body type was
        // String.
        returnType instanceof RawClass
      )
    )
  }
}

private class ServletWriterSourceToWritingMethodFlowConfig extends TaintTracking2::Configuration {
  ServletWriterSourceToWritingMethodFlowConfig() {
    this = "XSS::ServletWriterSourceToWritingMethodFlowConfig"
  }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof ServletWriterSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      sink.asExpr() = ma.getQualifier() and ma.getMethod() instanceof WritingMethod
    )
  }
}

private class WritingMethod extends Method {
  WritingMethod() {
    getDeclaringType().getASupertype*().hasQualifiedName("java.io", _) and
    (
      this.getName().matches("print%") or
      this.getName() = "append" or
      this.getName() = "format" or
      this.getName() = "write"
    )
  }
}

class ServletWriterSource extends MethodAccess {
  ServletWriterSource() {
    this.getMethod() instanceof ServletResponseGetWriterMethod
    or
    this.getMethod() instanceof ServletResponseGetOutputStreamMethod
    or
    exists(Method m | m = this.getMethod() |
      m.getDeclaringType().getQualifiedName() = "javax.servlet.jsp.JspContext" and
      m.getName() = "getOut"
    )
  }
}
