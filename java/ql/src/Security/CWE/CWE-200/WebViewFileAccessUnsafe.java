WebSettings settings = view.getSettings();

// BAD: WebView is configured to allow file access
settings.setAllowFileAccess(true);
settings.setAllowFileAccessFromURLs(true);
settings.setAllowUniversalAccessFromURLs(true);
