import java

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

/** The method `addJavascriptInterface` of the class `android.webkit.WebView` */
class WebViewAddJavascriptInterfaceMethod extends Method {
  WebViewAddJavascriptInterfaceMethod() {
    this.getDeclaringType() instanceof TypeWebView and
    this.hasName("addJavascriptInterface")
  }
}

/**
 * A method allowing any-local-file and cross-origin access in the class `android.webkit.WebSettings`.
 */
class CrossOriginAccessMethod extends Method {
  CrossOriginAccessMethod() {
    this.getDeclaringType() instanceof TypeWebSettings and
    this.hasName([
        "setAllowFileAccess", "setAllowUniversalAccessFromFileURLs",
        "setAllowFileAccessFromFileURLs"
      ])
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

/** The method `setAllowContentAccess` of the class `android.webkit.WebSettings` */
class AllowContentAccessMethod extends Method {
  AllowContentAccessMethod() {
    this.getDeclaringType() instanceof TypeWebSettings and
    this.hasName("setAllowContentAccess")
  }
}

/** The method `shouldOverrideUrlLoading` of the class `android.webkit.WebViewClient`. */
class ShouldOverrideUrlLoading extends Method {
  ShouldOverrideUrlLoading() {
    this.getDeclaringType().getASupertype*() instanceof TypeWebViewClient and
    this.hasName("shouldOverrideUrlLoading")
  }
}

/**
 * A method annotated with the `android.webkit.JavascriptInterface` annotation.
 */
class JavascriptInterfaceMethod extends Method {
  JavascriptInterfaceMethod() { this.hasAnnotation("android.webkit", "JavascriptInterface") }
}
