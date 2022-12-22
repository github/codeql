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

/**
 * A method access to a getter method which is private.
 *
 * In Kotlin, member accesses are translated to getter methods.
 */
private class PrivateGetterMethodAccess extends MethodAccess {
  PrivateGetterMethodAccess() {
    this instanceof MethodAccess and
    this.getMethod() instanceof GetterMethod and
    this.getMethod().isPrivate()
  }
}

/**
 * A flow configuration for tracking flow from the creation of a `WebView` object to a call of the `getSettings` method.
 */
private class WebViewGetSettingsConfiguration extends DataFlow::Configuration {
  WebViewGetSettingsConfiguration() { this = "WebViewGetSettingsConfiguration" }

  override predicate isSource(DataFlow::Node node) {
    node.asExpr().getType().(RefType) instanceof TypeWebViewOrSubclass and
    // To reduce duplicate results, we only consider WebView objects from
    // constructor and method calls, or method accesses which are cast to WebView.
    (
      node.asExpr() instanceof ClassInstanceExpr or
      node.asExpr() instanceof MethodAccess or
      node.asExpr().(CastExpr).getAChildExpr() instanceof MethodAccess
    ) and
    // Avoid duplicate results from Kotlin member accesses.
    not node.asExpr() instanceof PrivateGetterMethodAccess
  }

  override predicate isSink(DataFlow::Node node) {
    exists(MethodAccess ma |
      ma.getQualifier() = node.asExpr() and
      ma.getMethod() instanceof WebViewGetSettingsMethod
    )
  }
}

private class WebSettingsSetAllowContentAccessFalseConfiguration extends DataFlow::Configuration {
  WebSettingsSetAllowContentAccessFalseConfiguration() {
    this = "WebSettingsSetAllowContentAccessFalseConfiguration"
  }

  override predicate isSource(DataFlow::Node node) {
    node.asExpr().getType() instanceof TypeWebSettings
  }

  override predicate isSink(DataFlow::Node node) {
    // sink: settings.setAllowContentAccess(false)
    // or (in Kotlin): settings.allowContentAccess = false
    exists(MethodAccess ma |
      ma.getQualifier() = node.asExpr() and
      ma.getMethod().hasName("setAllowContentAccess") and
      ma.getArgument(0).(CompileTimeConstantExpr).getBooleanValue() = false
    )
  }
}

predicate hasContentAccessDisabled(Expr webview) {
  exists(
    DataFlow::Node wvSource, DataFlow::Node wvSink, WebViewGetSettingsConfiguration viewCfg,
    DataFlow::Node settingsSource, DataFlow::Node settingsSink,
    WebSettingsSetAllowContentAccessFalseConfiguration settingsCfg, MethodAccess getSettingsAccess
  |
    wvSource = DataFlow::exprNode(webview) and
    viewCfg.hasFlow(wvSource, wvSink) and
    settingsCfg.hasFlow(settingsSource, settingsSink) and
    getSettingsAccess.getQualifier() = wvSink.asExpr() and
    getSettingsAccess.getMethod() instanceof WebViewGetSettingsMethod and
    getSettingsAccess = settingsSource.asExpr()
  )
}

from Expr source, WebViewGetSettingsConfiguration cfg
where cfg.isSource(DataFlow::exprNode(source)) and not hasContentAccessDisabled(source)
select source,
  "Sensitive information may be exposed via a malicious link due to access of content:// links being permitted."
