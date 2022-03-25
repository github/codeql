import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow

/** The class `android.webkit.WebView`. */
class TypeWebView extends Class {
  TypeWebView() { this.hasQualifiedName("android.webkit", "WebView") }
}

/** The class `android.webkit.WebViewClient`. */
class TypeWebViewClient extends Class {
  TypeWebViewClient() { this.hasQualifiedName("android.webkit", "WebViewClient") }
}

/** The class `android.webkit.WebSettings`. */
class TypeWebSettings extends Class {
  TypeWebSettings() { this.hasQualifiedName("android.webkit", "WebSettings") }
}

/** The method `getSettings` of the class `android.webkit.WebView`. */
class WebViewGetSettingsMethod extends Method {
  WebViewGetSettingsMethod() {
    this.hasName("getSettings") and
    this.getDeclaringType() instanceof TypeWebView
  }
}

/** The method `loadUrl` or `postUrl` of the class `android.webkit.WebView`. */
class WebViewLoadUrlMethod extends Method {
  WebViewLoadUrlMethod() {
    this.getDeclaringType() instanceof TypeWebView and
    (this.hasName("loadUrl") or this.hasName("postUrl"))
  }
}

/** The method `getUrl` or `getOriginalUrl` of the class `android.webkit.WebView`. */
class WebViewGetUrlMethod extends Method {
  WebViewGetUrlMethod() {
    this.getDeclaringType() instanceof TypeWebView and
    (this.getName() = "getUrl" or this.getName() = "getOriginalUrl")
  }
}

/**
 * A method allowing any-local-file and cross-origin access in the class `android.webkit.WebSettings`.
 */
class CrossOriginAccessMethod extends Method {
  CrossOriginAccessMethod() {
    this.getDeclaringType() instanceof TypeWebSettings and
    this.hasName(["setAllowUniversalAccessFromFileURLs", "setAllowFileAccessFromFileURLs"])
  }
}

/**
 * The method `setJavaScriptEnabled` of the class `android.webkit.WebSettings`.
 */
class AllowJavaScriptMethod extends Method {
  AllowJavaScriptMethod() {
    this.getDeclaringType() instanceof TypeWebSettings and
    this.hasName("setJavaScriptEnabled")
  }
}

/** The method `setWebViewClient` of the class `android.webkit.WebView`. */
class WebViewSetWebViewClientMethod extends Method {
  WebViewSetWebViewClientMethod() {
    this.getDeclaringType() instanceof TypeWebView and
    this.hasName("setWebViewClient")
  }
}

/** The method `shouldOverrideUrlLoading` of the class `android.webkit.WebViewClient`. */
class ShouldOverrideUrlLoading extends Method {
  ShouldOverrideUrlLoading() {
    this.getDeclaringType().getASupertype*() instanceof TypeWebViewClient and
    this.hasName("shouldOverrideUrlLoading")
  }
}

private class WebkitSourceModels extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        "android.webkit;WebViewClient;true;doUpdateVisitedHistory;;;Parameter[1];remote",
        "android.webkit;WebViewClient;true;onLoadResource;;;Parameter[1];remote",
        "android.webkit;WebViewClient;true;onPageCommitVisible;;;Parameter[1];remote",
        "android.webkit;WebViewClient;true;onPageFinished;;;Parameter[1];remote",
        "android.webkit;WebViewClient;true;onPageStarted;;;Parameter[1];remote",
        "android.webkit;WebViewClient;true;onReceivedError;(WebView,int,String,String);;Parameter[3];remote",
        "android.webkit;WebViewClient;true;onReceivedError;(WebView,WebResourceRequest,WebResourceError);;Parameter[1];remote",
        "android.webkit;WebViewClient;true;onReceivedHttpError;;;Parameter[1];remote",
        "android.webkit;WebViewClient;true;onSafeBrowsingHit;;;Parameter[1];remote",
        "android.webkit;WebViewClient;true;shouldInterceptRequest;;;Parameter[1];remote",
        "android.webkit;WebViewClient;true;shouldOverrideUrlLoading;;;Parameter[1];remote"
      ]
  }
}

private class WebkitSummaryModels extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "android.webkit;WebResourceRequest;true;getRequestHeaders;;;Argument[-1];ReturnValue;taint",
        "android.webkit;WebResourceRequest;true;getUrl;;;Argument[-1];ReturnValue;taint"
      ]
  }
}
