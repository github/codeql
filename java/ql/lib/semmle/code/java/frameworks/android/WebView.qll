import java

class TypeWebView extends Class {
  TypeWebView() { this.hasQualifiedName("android.webkit", "WebView") }
}

class TypeWebViewClient extends Class {
  TypeWebViewClient() { this.hasQualifiedName("android.webkit", "WebViewClient") }
}

class TypeWebSettings extends Class {
  TypeWebSettings() { this.hasQualifiedName("android.webkit", "WebSettings") }
}

class WebViewGetSettingsMethod extends Method {
  WebViewGetSettingsMethod() {
    this.hasName("getSettings") and
    this.getDeclaringType() instanceof TypeWebView
  }
}

class WebViewLoadUrlMethod extends Method {
  WebViewLoadUrlMethod() {
    this.getDeclaringType() instanceof TypeWebView and
    (this.hasName("loadUrl") or this.hasName("postUrl"))
  }
}

class WebViewGetUrlMethod extends Method {
  WebViewGetUrlMethod() {
    this.getDeclaringType() instanceof TypeWebView and
    (this.getName() = "getUrl" or this.getName() = "getOriginalUrl")
  }
}
