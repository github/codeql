/**
 * @name Android WebView settings permits content access
 * @id java/android/websettings-permit-contentacces
 * @description Access to content providers in a WebView can permit access to protected information by loading content:// links.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @tags security
 *      external/cwe/cwe-200
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.frameworks.android.WebView

private class TypeWebViewOrSubclass extends RefType {
  TypeWebViewOrSubclass() { this.getASupertype*() instanceof TypeWebView }
}

// source: WebView
// sink: settings.setAllowContentAccess(false)
class WebViewDisallowContentAccessConfiguration extends DataFlow::Configuration {
  WebViewDisallowContentAccessConfiguration() { this = "WebViewDisallowContentAccessConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().getType() instanceof TypeWebViewOrSubclass and
    (
      source.asExpr() instanceof ClassInstanceExpr or
      source.asExpr() instanceof MethodAccess or
      source.asExpr().(CastExpr).getAChildExpr() instanceof MethodAccess
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma = sink.asExpr() and
      ma.getMethod().hasName("setAllowContentAccess") and
      ma.getArgument(0).(CompileTimeConstantExpr).getBooleanValue() = false
    )
  }
}

from DataFlow::Node e, WebViewDisallowContentAccessConfiguration cfg
where cfg.isSource(e) and not cfg.hasFlow(e, _)
select e
