deprecated module;

import java
import semmle.code.java.dataflow.DataFlow

/**
 * `WebRequest` interface is a source of tainted data.
 */
class WebRequestSource extends DataFlow::Node {
  WebRequestSource() {
    exists(MethodCall ma, Method m | ma.getMethod() = m |
      m.getDeclaringType() instanceof WebRequest and
      (
        m.hasName("getHeader") or
        m.hasName("getHeaderValues") or
        m.hasName("getHeaderNames") or
        m.hasName("getParameter") or
        m.hasName("getParameterValues") or
        m.hasName("getParameterNames") or
        m.hasName("getParameterMap")
      ) and
      ma = this.asExpr()
    )
  }
}

class WebRequest extends RefType {
  WebRequest() { this.hasQualifiedName("org.springframework.web.context.request", "WebRequest") }
}
