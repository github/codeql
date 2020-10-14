/**
 * @name Unsafe resource fetching in Android webview
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

/**
 * Methods allowing any-local-file and universal access in the WebSettings class
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
 * Holds if `ma` is a method invocation against `va` and `va.setJavaScriptEnabled(true)` occurs elsewhere in the program
 */
predicate isJSEnabled(Variable v) {
  exists(VarAccess va, MethodAccess jsa |
    v.getAnAccess() = va and
    jsa.getQualifier() = v.getAnAccess() and
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
    (
      this.getMethod().hasName("loadUrl") or
      this.getMethod().hasName("postUrl")
    )
  }
}

/**
 * Method access to external inputs of `android.content.Intent` object
 */
class IntentGetExtraMethodAccess extends MethodAccess {
  IntentGetExtraMethodAccess() {
    this.getMethod().getName().regexpMatch("get\\w+Extra") and
    this.getMethod().getDeclaringType() instanceof TypeIntent
    or
    this.getMethod().getName().regexpMatch("get\\w+") and
    this.getQualifier().(MethodAccess).getMethod().hasName("getExtras") and
    this.getQualifier().(MethodAccess).getMethod().getDeclaringType() instanceof TypeIntent
  }
}

/**
 * Source of fetching urls
 */
class UntrustedResourceSource extends RemoteFlowSource {
  UntrustedResourceSource() {
    exists(IntentGetExtraMethodAccess ma |
      this.asExpr().(VarAccess).getVariable().getAnAssignedValue() = ma
    )
  }

  override string getSourceType() {
    result = "user input vulnerable to XSS and sensitive resource disclosure attacks" and
    exists(MethodAccess ma |
      ma.getMethod() instanceof CrossOriginAccessMethod and //High precision match of unsafe resource fetching
      ma.getArgument(0).(BooleanLiteral).getBooleanValue() = true
    )
    or
    result = "user input potentially vulnerable to XSS and sensitive resource disclosure attacks" and
    not exists(MethodAccess ma |
      ma.getMethod() instanceof CrossOriginAccessMethod and //High precision match of unsafe resource fetching
      ma.getArgument(0).(BooleanLiteral).getBooleanValue() = true
    )
  }
}

/**
 * Holds if `ma` loads url `sink`
 */
predicate fetchResource(FetchResourceMethodAccess ma, Expr sink) { sink = ma.getArgument(0) }

/**
 * Sink of fetching urls
 */
class UrlResourceSink extends DataFlow::ExprNode {
  UrlResourceSink() { fetchResource(_, this.getExpr()) }

  FetchResourceMethodAccess getMethodAccess() { fetchResource(result, this.getExpr()) }
}

class FetchUntrustedResourceConfiguration extends TaintTracking::Configuration {
  FetchUntrustedResourceConfiguration() { this = "FetchUntrustedResourceConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof UntrustedResourceSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UrlResourceSink }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, FetchUntrustedResourceConfiguration conf
where
  exists(VarAccess webviewVa, MethodAccess getSettingsMa, Variable v |
    conf.hasFlowPath(source, sink) and
    sink.getNode().(UrlResourceSink).getMethodAccess().getQualifier() = webviewVa and
    webviewVa.getVariable().getAnAccess() = getSettingsMa.getQualifier() and
    v.getAnAssignedValue() = getSettingsMa and
    isJSEnabled(v)
  )
select sink.getNode().(UrlResourceSink).getMethodAccess(), source, sink,
  "Unsafe resource fetching in Android webview due to $@.", source.getNode(),
  source.getNode().(UntrustedResourceSource).getSourceType()
