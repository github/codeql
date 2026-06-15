WebSettings settings = webview.getSettings();

// BAD: WebView is configured to allow content access
settings.setAllowContentAccess(true);
