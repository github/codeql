import java
import semmle.code.java.frameworks.Servlets
import semmle.code.java.frameworks.android.WebView
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.RemoteFlowSinks

/**
 * A data flow sink for cross-site scripting (XSS) vulnerabilities.
 *
 * Any XSS sink is also a remote flow sink, so this class contributes
 * to the abstract class `RemoteFlowSink`.
 */
class XssSink extends DataFlow::ExprNode, RemoteFlowSink {
  XssSink() {
    exists(HttpServletResponseSendErrorMethod m, MethodAccess ma |
      ma.getMethod() = m and
      this.getExpr() = ma.getArgument(1)
    )
    or
    exists(ServletWriterSourceToWritingMethodFlowConfig writer, MethodAccess ma |
      ma.getMethod() instanceof WritingMethod and
      writer.hasFlowToExpr(ma.getQualifier()) and
      this.getExpr() = ma.getArgument(_)
    )
    or
    exists(Method m |
      m.getDeclaringType() instanceof TypeWebView and
      (
        m.getAReference().getArgument(0) = this.getExpr() and m.getName() = "loadData"
        or
        m.getAReference().getArgument(0) = this.getExpr() and m.getName() = "loadUrl"
        or
        m.getAReference().getArgument(1) = this.getExpr() and m.getName() = "loadDataWithBaseURL"
      )
    )
  }
}

class ServletWriterSourceToWritingMethodFlowConfig extends TaintTracking::Configuration {
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

class WritingMethod extends Method {
  WritingMethod() {
    getDeclaringType().getASupertype*().hasQualifiedName("java.io", _) and
    (
      this.getName().matches("print%") or
      this.getName() = "append" or
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
