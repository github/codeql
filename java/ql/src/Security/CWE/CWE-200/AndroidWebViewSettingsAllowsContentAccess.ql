/**
 * @name Android WebView settings allows access to content links
 * @id java/android/websettings-allow-content-access
 * @description Access to content providers in a WebView can allow access to protected information by loading content:// links.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @security-severity 6.5
 * @tags security
 *      external/cwe/cwe-200
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.frameworks.android.WebView

/** Represents `android.webkit.WebView` and its subclasses. */
private class TypeWebViewOrSubclass extends RefType {
  TypeWebViewOrSubclass() { this.getASupertype*() instanceof TypeWebView }
}

/**
 * A method access to a getter method which is private.
 *
 * In Kotlin, member accesses are translated to getter methods.
 */
private class PrivateGetterMethodAccess extends MethodAccess {
  PrivateGetterMethodAccess() {
    this.getMethod() instanceof GetterMethod and
    this.getMethod().isPrivate()
  }
}

/** A source for `android.webkit.WebView` objects. */
class WebViewSource extends DataFlow::Node {
  WebViewSource() {
    this.getType() instanceof TypeWebViewOrSubclass and
    // To reduce duplicate results, we only consider WebView objects from
    // constructor and method calls, or method accesses which are cast to WebView.
    (
      this.asExpr() instanceof ClassInstanceExpr or
      this.asExpr() instanceof MethodAccess or
      this.asExpr().(CastExpr).getAChildExpr() instanceof MethodAccess
    ) and
    // Avoid duplicate results from Kotlin member accesses.
    not this.asExpr() instanceof PrivateGetterMethodAccess
  }
}

/**
 * A sink representing a call to `android.webkit.WebSettings.setAllowContentAccess` that
 * disables content access.
 */
class WebSettingsDisallowContentAccessSink extends DataFlow::Node {
  WebSettingsDisallowContentAccessSink() {
    exists(MethodAccess ma |
      ma.getQualifier() = this.asExpr() and
      ma.getMethod() instanceof AllowContentAccessMethod and
      ma.getArgument(0).(CompileTimeConstantExpr).getBooleanValue() = false
    )
  }
}

class WebViewDisallowContentAccessConfiguration extends TaintTracking::Configuration {
  WebViewDisallowContentAccessConfiguration() { this = "WebViewDisallowContentAccessConfiguration" }

  override predicate isSource(DataFlow::Node node) { node instanceof WebViewSource }

  /**
   * Holds if the step from `node1` to `node2` is a dataflow step that gets the `WebSettings` object
   * from the `getSettings` method of a `WebView` object.
   *
   * This step is only valid when `state1` is empty and `state2` indicates that the `WebSettings` object
   * has been accessed.
   */
  override predicate isAdditionalTaintStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    state1 instanceof DataFlow::FlowStateEmpty and
    state2 = "WebSettings" and
    // settings = webView.getSettings()
    // ^node2   = ^node1
    exists(MethodAccess ma |
      ma = node2.asExpr() and
      ma.getQualifier() = node1.asExpr() and
      ma.getMethod() instanceof WebViewGetSettingsMethod
    )
  }

  override predicate isSink(DataFlow::Node node, DataFlow::FlowState state) {
    state = "WebSettings" and
    node instanceof WebSettingsDisallowContentAccessSink
  }
}

from Expr e
where
  // explicit: setAllowContentAccess(true)
  exists(MethodAccess ma |
    ma = e and
    ma.getMethod() instanceof AllowContentAccessMethod and
    ma.getArgument(0).(CompileTimeConstantExpr).getBooleanValue() = true
  )
  or
  // implicit: no setAllowContentAccess(false)
  exists(WebViewSource source |
    source.asExpr() = e and
    not any(WebViewDisallowContentAccessConfiguration cfg).hasFlow(source, _)
  )
select e,
  "Sensitive information may be exposed via a malicious link due to access to content:// links being allowed in this WebView."
