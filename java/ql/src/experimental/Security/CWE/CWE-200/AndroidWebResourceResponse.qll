/** Provides Android methods relating to web resource response. */

import java
import semmle.code.java.dataflow.FlowSources

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

/** The `shouldInterceptRequest` method of Android's `WebViewClient` class. */
class ShouldInterceptRequestMethod extends Method {
  ShouldInterceptRequestMethod() {
    this.hasName("shouldInterceptRequest") and
    this.getDeclaringType().getASupertype*() instanceof TypeWebViewClient and
    this.getReturnType() instanceof WebResourceResponse
  }
}

/** A method call to `setWebViewClient` of `WebView`. */
class SetWebViewClientMethodAccess extends MethodAccess {
  SetWebViewClientMethodAccess() {
    this.getMethod().hasName("setWebViewClient") and
    this.getMethod().getDeclaringType().getASupertype*() instanceof TypeWebView and
    this.getMethod().getParameterType(0) instanceof TypeWebViewClient
  }
}

/** A sink representing a constructor call of `WebResourceResponse` in Android `WebViewClient`. */
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
 * Value step from a fetching url call of `WebView` to `WebViewClient`.
 */
private class FetchUrlStep extends AdditionalValueStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(
      // webview.loadUrl(url) -> webview.setWebViewClient(new WebViewClient() { shouldInterceptRequest(view, url) });
      WebViewLoadUrlMethod lm, ShouldInterceptRequestMethod im, SetWebViewClientMethodAccess sma
    |
      sma.getArgument(0).getType() = im.getDeclaringType().getASupertype*() and
      exists(MethodAccess lma |
        lma.getMethod() = lm and
        lma.getQualifier().getType() = sma.getQualifier().getType() and
        pred.asExpr() = lma.getArgument(0) and
        succ.asExpr() = im.getParameter(1).getAnAccess()
      )
    )
  }
}

/** Value/taint steps relating to url loading and file reading in an Android application. */
private class LoadUrlSource extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "java.io;FileInputStream;true;FileInputStream;;;Argument[0];Argument[-1];taint",
        "android.net;Uri;false;getPath;;;Argument[0];ReturnValue;value",
        "android.webkit;WebResourceRequest;false;getUrl;;;Argument[-1];ReturnValue;value"
      ]
  }
}
