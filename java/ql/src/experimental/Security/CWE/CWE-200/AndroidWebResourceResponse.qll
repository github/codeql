/** Provides Android methods relating to web resource response. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.java.frameworks.android.WebView

/**
 * The Android class `android.webkit.WebResourceRequest` for handling web requests.
 */
class WebResourceRequest extends RefType {
  WebResourceRequest() { this.hasQualifiedName("android.webkit", "WebResourceRequest") }
}

/**
 * The Android class `android.webkit.WebResourceResponse` for rendering web responses.
 */
class WebResourceResponse extends RefType {
  WebResourceResponse() { this.hasQualifiedName("android.webkit", "WebResourceResponse") }
}

/** The `shouldInterceptRequest` method of a class implementing `WebViewClient`. */
class ShouldInterceptRequestMethod extends Method {
  ShouldInterceptRequestMethod() {
    this.hasName("shouldInterceptRequest") and
    this.getDeclaringType().getASupertype*() instanceof TypeWebViewClient
  }
}

/** A method call to `WebView.setWebViewClient`. */
class SetWebViewClientMethodAccess extends MethodAccess {
  SetWebViewClientMethodAccess() {
    this.getMethod().hasName("setWebViewClient") and
    this.getMethod().getDeclaringType().getASupertype*() instanceof TypeWebView
  }
}

/** A sink representing the data argument of a call to the constructor of `WebResourceResponse`. */
class WebResourceResponseSink extends DataFlow::Node {
  WebResourceResponseSink() {
    exists(ConstructorCall cc |
      cc.getConstructedType() instanceof WebResourceResponse and
      (
        this.asExpr() = cc.getArgument(2) and cc.getNumArgument() = 3 // WebResourceResponse(String mimeType, String encoding, InputStream data)
        or
        this.asExpr() = cc.getArgument(5) and cc.getNumArgument() = 6 // WebResourceResponse(String mimeType, String encoding, int statusCode, String reasonPhrase, Map<String, String> responseHeaders, InputStream data)
      )
    )
  }
}

/**
 * A value step from the URL argument of `WebView::loadUrl` to the URL parameter of
 * `WebViewClient::shouldInterceptRequest`.
 */
private class FetchUrlStep extends AdditionalValueStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(
      // webview.loadUrl(url) -> webview.setWebViewClient(new WebViewClient() { shouldInterceptRequest(view, url) });
      MethodAccess lma, ShouldInterceptRequestMethod im, SetWebViewClientMethodAccess sma
    |
      sma.getArgument(0).getType() = im.getDeclaringType().getASupertype*() and
      lma.getMethod() instanceof WebViewLoadUrlMethod and
      lma.getQualifier().getType() = sma.getQualifier().getType() and
      pred.asExpr() = lma.getArgument(0) and
      succ.asParameter() = im.getParameter(1)
    )
  }
}

/** Value/taint steps relating to url loading and file reading in an Android application. */
private class LoadUrlSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "java.io;FileInputStream;true;FileInputStream;;;Argument[0];Argument[-1];taint",
        "android.webkit;WebResourceRequest;false;getUrl;;;Argument[-1];ReturnValue;taint"
      ]
  }
}
