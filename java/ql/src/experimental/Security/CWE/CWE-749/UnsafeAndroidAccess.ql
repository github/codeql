/**
 * @name Unsafe resource fetching in Android webview
 * @id java/android/unsafe-android-webview-fetch
 * @description JavaScript rendered inside WebViews can access any protected application file and web resource from any origin
 * @kind path-problem
 * @tags security
 *       external/cwe/cwe-749
 *       external/cwe/cwe-079
 */

import java
import semmle.code.java.frameworks.android.Intent
import semmle.code.java.frameworks.android.WebView
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

/**
 * Methods allowing any-local-file and cross-origin access in the WebSettings class
 */
class CrossOriginAccessMethod extends Method {
  CrossOriginAccessMethod() {
    this.getDeclaringType() instanceof TypeWebSettings and
    (
      this.hasName("setAllowUniversalAccessFromFileURLs") or
      this.hasName("setAllowFileAccessFromFileURLs")
    )
  }
}

/**
 * `setJavaScriptEnabled` method for the webview
 */
class AllowJavaScriptMethod extends Method {
  AllowJavaScriptMethod() {
    this.getDeclaringType() instanceof TypeWebSettings and
    this.hasName("setJavaScriptEnabled")
  }
}

/**
 * Holds if a call to `v.setJavaScriptEnabled(true)` exists
 */
predicate isJSEnabled(Variable v) {
  exists(MethodAccess jsa |
    v.getAnAccess() = jsa.getQualifier() and
    jsa.getMethod() instanceof AllowJavaScriptMethod and
    jsa.getArgument(0).(BooleanLiteral).getBooleanValue() = true
  )
}

/**
 * Fetch URL method call on the `android.webkit.WebView` object
 */
class FetchResourceMethodAccess extends MethodAccess {
  FetchResourceMethodAccess() {
    this.getMethod().getDeclaringType() instanceof TypeWebView and
    this.getMethod().hasName(["loadUrl", "postUrl"])
  }
}

/**
 * Holds if `ma` loads URL `sink`
 */
predicate fetchResource(FetchResourceMethodAccess ma, Expr sink) { sink = ma.getArgument(0) }

/**
 * A URL argument to a `loadUrl` or `postUrl` call, considered as a sink.
 */
class UrlResourceSink extends DataFlow::ExprNode {
  UrlResourceSink() { fetchResource(_, this.getExpr()) }

  /** Gets the fetch method that fetches this sink URL. */
  FetchResourceMethodAccess getMethodAccess() { fetchResource(result, this.getExpr()) }

  /**
   * Holds if cross-origin access is enabled for this resource fetch.
   *
   * Specifically this looks for code like
   * `webView.getSettings().setAllow[File|Universal]AccessFromFileURLs(true);`
   */
  predicate crossOriginAccessEnabled() {
    exists(MethodAccess ma, MethodAccess getSettingsMa |
      ma.getMethod() instanceof CrossOriginAccessMethod and
      ma.getArgument(0).(BooleanLiteral).getBooleanValue() = true and
      ma.getQualifier().(VarAccess).getVariable().getAnAssignedValue() = getSettingsMa and
      getSettingsMa.getMethod() instanceof WebViewGetSettingsMethod and
      getSettingsMa.getQualifier().(VarAccess).getVariable().getAnAccess() =
        getMethodAccess().getQualifier()
    )
  }

  /**
   * Returns a description of this vulnerability, assuming Javascript is enabled and
   * the fetched URL is attacker-controlled.
   */
  string getSinkType() {
    if crossOriginAccessEnabled()
    then result = "user input vulnerable to cross-origin and sensitive resource disclosure attacks"
    else result = "user input vulnerable to XSS attacks"
  }
}

/**
 * Taint configuration tracking flow from untrusted inputs to `loadUrl` or `postUrl` calls.
 */
class FetchUntrustedResourceConfiguration extends TaintTracking::Configuration {
  FetchUntrustedResourceConfiguration() { this = "FetchUntrustedResourceConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof UrlResourceSink and
    exists(VarAccess webviewVa, MethodAccess getSettingsMa, Variable v |
      sink.(UrlResourceSink).getMethodAccess().getQualifier() = webviewVa and
      getSettingsMa.getMethod() instanceof WebViewGetSettingsMethod and
      webviewVa.getVariable().getAnAccess() = getSettingsMa.getQualifier() and
      v.getAnAssignedValue() = getSettingsMa and
      isJSEnabled(v)
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, FetchUntrustedResourceConfiguration conf
where conf.hasFlowPath(source, sink)
select sink.getNode().(UrlResourceSink).getMethodAccess(), source, sink,
  "Unsafe resource fetching in Android webview due to $@.", source.getNode(),
  sink.getNode().(UrlResourceSink).getSinkType()
