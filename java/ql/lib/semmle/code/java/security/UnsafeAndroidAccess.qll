/**
 * Provides classes to reason about Unsafe Resource Fetching vulnerabilities in Android.
 */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSinks
private import semmle.code.java.frameworks.android.WebView
private import semmle.code.java.frameworks.kotlin.Kotlin

/**
 * A sink that represents a method that fetches a web resource in Android.
 *
 * Extend this class to add your own Unsafe Resource Fetching sinks.
 */
abstract class UrlResourceSink extends ApiSinkNode {
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
    exists(WebViewRef webview |
      webViewLoadUrl(this.asExpr(), webview) and
      isAllowFileAccessEnabled(webview)
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
    exists(WebViewRef webview |
      webViewLoadUrl(this.asExpr(), webview) and
      isJSEnabled(webview)
    )
  }

  override string getSinkType() { result = "user input vulnerable to XSS attacks" }
}

private class WebViewRef extends Element {
  WebViewRef() {
    this.(RefType).getASourceSupertype*() instanceof TypeWebView or
    this.(Variable).getType().(RefType).getASourceSupertype*() instanceof TypeWebView
  }

  /** Gets an access to this WebView as a data flow node. */
  DataFlow::Node getAnAccess() {
    exists(DataFlow::InstanceAccessNode t | t.getType() = this and result = t |
      t.isOwnInstanceAccess() or t.getInstanceAccess().isEnclosingInstanceAccess(this)
    )
    or
    exists(Variable v | result.asExpr() = v.getAnAccess() |
      v = this
      or
      applyReceiverVariable(this, v)
    )
  }
}

/**
 * Holds if `p` is the lambda parameter that holds the receiver of an `apply` expression in Kotlin,
 * and `v` is the variable of the receiver in the outer scope.
 */
private predicate applyReceiverVariable(Parameter p, Variable v) {
  exists(LambdaExpr lambda, KotlinApply apply |
    p.getCallable() = lambda.asMethod() and
    lambda = apply.getLambdaArg() and
    v = apply.getReceiver().(VarAccess).getVariable()
  )
}

/**
 * Holds if a `WebViewLoadUrlMethod` is called on an access of `webview`
 * with `urlArg` as its first argument.
 */
private predicate webViewLoadUrl(Argument urlArg, WebViewRef webview) {
  exists(MethodCall loadUrl |
    loadUrl.getArgument(0) = urlArg and
    loadUrl.getMethod() instanceof WebViewLoadUrlMethod
  |
    webview.getAnAccess() = DataFlow::exprNode(loadUrl.getQualifier().getUnderlyingExpr())
    or
    webview.getAnAccess() = DataFlow::getInstanceArgument(loadUrl)
    or
    // `webview` is received as a parameter of an event method in a custom `WebViewClient`,
    // so we need to find `WebViews` that use that specific `WebViewClient`.
    exists(WebViewClientEventMethod eventMethod, MethodCall setWebClient |
      setWebClient.getMethod() instanceof WebViewSetWebViewClientMethod and
      setWebClient.getArgument(0).getType() = eventMethod.getDeclaringType() and
      loadUrl.getQualifier().getUnderlyingExpr() = eventMethod.getWebViewParameter().getAnAccess()
    |
      webview.getAnAccess() = DataFlow::exprNode(setWebClient.getQualifier().getUnderlyingExpr()) or
      webview.getAnAccess() = DataFlow::getInstanceArgument(setWebClient)
    )
  )
}

/**
 * Holds if `webview`'s option `setJavascriptEnabled`
 * has been set to `true` via a `WebSettings` object obtained from it.
 */
private predicate isJSEnabled(WebViewRef webview) {
  exists(MethodCall allowJs, MethodCall settings |
    allowJs.getMethod() instanceof AllowJavaScriptMethod and
    allowJs.getArgument(0).(CompileTimeConstantExpr).getBooleanValue() = true and
    settings.getMethod() instanceof WebViewGetSettingsMethod and
    DataFlow::localExprFlow(settings, allowJs.getQualifier()) and
    DataFlow::localFlow(webview.getAnAccess(), DataFlow::getInstanceArgument(settings))
  )
}

/**
 * Holds if `webview`'s options `setAllowUniversalAccessFromFileURLs` or
 * `setAllowFileAccessFromFileURLs` have been set to `true` via a `WebSettings` object
 *  obtained from it.
 */
private predicate isAllowFileAccessEnabled(WebViewRef webview) {
  exists(MethodCall allowFileAccess, MethodCall settings |
    allowFileAccess.getMethod() instanceof CrossOriginAccessMethod and
    allowFileAccess.getArgument(0).(CompileTimeConstantExpr).getBooleanValue() = true and
    settings.getMethod() instanceof WebViewGetSettingsMethod and
    DataFlow::localExprFlow(settings, allowFileAccess.getQualifier()) and
    DataFlow::localFlow(webview.getAnAccess(), DataFlow::getInstanceArgument(settings))
  )
}

/** A method of the class `WebViewClient` that handles an event. */
private class WebViewClientEventMethod extends Method {
  WebViewClientEventMethod() {
    this.getDeclaringType().getASupertype*() instanceof TypeWebViewClient and
    this.hasName([
        "shouldOverrideUrlLoading", "shouldInterceptRequest", "onPageStarted", "onPageFinished",
        "onLoadResource", "onPageCommitVisible", "onTooManyRedirects"
      ])
  }

  /** Gets a `WebView` parameter of this method. */
  Parameter getWebViewParameter() {
    result = this.getAParameter() and
    result.getType() instanceof TypeWebView
  }
}
