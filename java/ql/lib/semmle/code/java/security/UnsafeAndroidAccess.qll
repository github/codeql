/**
 * Provides classes to reason about Unsafe Resource Fetching vulnerabilities in Android.
 */

import java
private import semmle.code.java.frameworks.android.WebView
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow

/**
 * A sink that represents a method that fetches a web resource in Android.
 *
 * Extend this class to add your own Unsafe Resource Fetching sinks.
 */
abstract class UrlResourceSink extends DataFlow::Node {
  /**
   * Gets a description of this vulnerability.
   */
  abstract string getSinkType();
}

/**
 * A cross-origin access enabled resource fetch.
 *
 * Only considered a valid sink when JavaScript is also enabled.
 */
private class CrossOriginUrlResourceSink extends JavaScriptEnabledUrlResourceSink {
  CrossOriginUrlResourceSink() {
    exists(Variable settings, MethodAccess ma |
      webViewLoadUrl(this.asExpr(), settings) and
      ma.getMethod() instanceof CrossOriginAccessMethod and
      ma.getArgument(0).(BooleanLiteral).getBooleanValue() = true and
      ma.getQualifier() = settings.getAnAccess()
    )
  }

  override string getSinkType() {
    result = "user input vulnerable to cross-origin and sensitive resource disclosure attacks"
  }
}

/**
 * JavaScript enabled resource fetch.
 */
private class JavaScriptEnabledUrlResourceSink extends UrlResourceSink {
  JavaScriptEnabledUrlResourceSink() {
    exists(Variable settings |
      webViewLoadUrl(this.asExpr(), settings) and
      isJSEnabled(settings)
    )
  }

  override string getSinkType() { result = "user input vulnerable to XSS attacks" }
}

/**
 * Holds if a `WebViewLoadUrlMethod` method is called with the given `urlArg` on a
 * WebView with settings stored in `settings`.
 */
private predicate webViewLoadUrl(Expr urlArg, Variable settings) {
  exists(MethodAccess loadUrl, Variable webview, MethodAccess getSettings |
    loadUrl.getArgument(0) = urlArg and
    loadUrl.getMethod() instanceof WebViewLoadUrlMethod and
    loadUrl.getQualifier() = webview.getAnAccess() and
    getSettings.getMethod() instanceof WebViewGetSettingsMethod and
    webview.getAnAccess() = getSettings.getQualifier() and
    settings.getAnAssignedValue() = getSettings
  )
}

/**
 * A method allowing any-local-file and cross-origin access in the WebSettings class.
 */
private class CrossOriginAccessMethod extends Method {
  CrossOriginAccessMethod() {
    this.getDeclaringType() instanceof TypeWebSettings and
    this.hasName(["setAllowUniversalAccessFromFileURLs", "setAllowFileAccessFromFileURLs"])
  }
}

/**
 * The `setJavaScriptEnabled` method for the webview.
 */
private class AllowJavaScriptMethod extends Method {
  AllowJavaScriptMethod() {
    this.getDeclaringType() instanceof TypeWebSettings and
    this.hasName("setJavaScriptEnabled")
  }
}

/**
 * Holds if a call to `v.setJavaScriptEnabled(true)` exists.
 */
private predicate isJSEnabled(Variable v) {
  exists(MethodAccess jsa |
    v.getAnAccess() = jsa.getQualifier() and
    jsa.getMethod() instanceof AllowJavaScriptMethod and
    jsa.getArgument(0).(BooleanLiteral).getBooleanValue() = true
  )
}
