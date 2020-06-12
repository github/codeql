/**
 * @name Unsafe resource loading in Android webview
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
 * Allow universal access methods in the WebSettings class
 */
class AllowUniversalAccessMethod extends Method {
  AllowUniversalAccessMethod() {
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
 * Check whether JavaScript is enabled in the webview with universal resource access
 */
predicate isJSEnabled(MethodAccess ma) {
  exists(VarAccess va, MethodAccess jsa |
    ma.getQualifier() = va and
    jsa.getQualifier() = va.getVariable().getAnAccess() and
    jsa.getMethod() instanceof AllowJavaScriptMethod and
    jsa.getArgument(0).(BooleanLiteral).getBooleanValue() = true
  )
}

/**
 * Load URL method call on the `android.webkit.WebView` object
 */
class LoadResourceMethodAccess extends MethodAccess {
  LoadResourceMethodAccess() {
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
 * Source of loading urls
 */
class UntrustedResourceSource extends RemoteFlowSource {
  UntrustedResourceSource() {
    exists(MethodAccess ma |
      ma instanceof IntentGetExtraMethodAccess and
      this.asExpr().(VarAccess).getVariable().getAnAssignedValue() = ma
    )
  }

  override string getSourceType() {
    result = "user input vulnerable to XSS and sensitive resource disclosure attacks" and
    exists(MethodAccess ma |
      ma.getMethod() instanceof AllowUniversalAccessMethod and //High precision match of unsafe resource loading
      ma.getArgument(0).(BooleanLiteral).getBooleanValue() = true
    )
    or
    result = "user input potentially vulnerable to XSS and sensitive resource disclosure attacks" and
    not exists(MethodAccess ma |
      ma.getMethod() instanceof AllowUniversalAccessMethod and //High precision match of unsafe resource loading
      ma.getArgument(0).(BooleanLiteral).getBooleanValue() = true
    )
  }
}

/**
 * load externally controlled data from loadUntrustedResource
 */
predicate loadUntrustedResource(MethodAccess ma, Expr sink) {
  ma instanceof LoadResourceMethodAccess and
  sink = ma.getArgument(0)
}

/**
 * Sink of loading urls
 */
class UntrustedResourceSink extends DataFlow::ExprNode {
  UntrustedResourceSink() { loadUntrustedResource(_, this.getExpr()) }

  MethodAccess getMethodAccess() { loadUntrustedResource(result, this.getExpr()) }
}

class LoadUntrustedResourceConfiguration extends TaintTracking::Configuration {
  LoadUntrustedResourceConfiguration() { this = "LoadUntrustedResourceConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof UntrustedResourceSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UntrustedResourceSink }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, LoadUntrustedResourceConfiguration conf
where
  exists(VarAccess webviewVa, MethodAccess getSettingsMa, MethodAccess ma |
    conf.hasFlowPath(source, sink) and
    sink.getNode().(UntrustedResourceSink).getMethodAccess().getQualifier() = webviewVa and
    webviewVa.getVariable().getAnAccess() = getSettingsMa.getQualifier() and
    ma.getQualifier().(VarAccess).getVariable().getAnAssignedValue() = getSettingsMa and
    isJSEnabled(ma)
  )
select sink.getNode().(UntrustedResourceSink).getMethodAccess(), source, sink,
  "Unsafe resource loading in Android webview due to $@.", source.getNode(),
  source.getNode().(UntrustedResourceSource).getSourceType()
