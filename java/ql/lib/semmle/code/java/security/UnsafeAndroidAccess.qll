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
    exists(WebViewRef webview |
      webViewLoadUrl(this.asExpr(), webview.getAnAccess()) and
      isAllowFileAccessEnabled(webview.getAnAccess())
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
      isJSEnabled(webview.getAnAccess()) and
      webViewLoadUrl(this.asExpr(), webview.getAnAccess())
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
    result = DataFlow::exprNode(this.(Variable).getAnAccess())
  }
}

private Expr getUnderlyingExpr(Expr e) {
  if e instanceof CastExpr or e instanceof UnaryExpr
  then
    result = getUnderlyingExpr(e.(CastExpr).getExpr()) or
    result = getUnderlyingExpr(e.(UnaryExpr).getExpr())
  else result = e
}

/**
 * Holds if a `WebViewLoadUrlMethod` is called on `webview`
 * with `urlArg` as its first argument.
 */
private predicate webViewLoadUrl(Argument urlArg, DataFlow::Node webview) {
  exists(MethodAccess loadUrl |
    loadUrl.getArgument(0) = urlArg and
    loadUrl.getMethod() instanceof WebViewLoadUrlMethod
  |
    webview = DataFlow::exprNode(getUnderlyingExpr(loadUrl.getQualifier()))
    or
    webview = DataFlow::getInstanceArgument(loadUrl)
    or
    // `webview` is received as a parameter of an event method in a custom `WebViewClient`,
    // so we need to find WebViews that use that specific `WebViewClient`.
    exists(WebViewClientEventMethod eventMethod, MethodAccess setWebClient |
      setWebClient.getMethod() instanceof WebViewSetWebViewClientMethod and
      setWebClient.getArgument(0).getType() = eventMethod.getDeclaringType() and
      getUnderlyingExpr(loadUrl.getQualifier()) = eventMethod.getWebViewParameter().getAnAccess()
    |
      webview = DataFlow::exprNode(getUnderlyingExpr(setWebClient.getQualifier()))
      or
      webview = DataFlow::getInstanceArgument(setWebClient)
    )
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
