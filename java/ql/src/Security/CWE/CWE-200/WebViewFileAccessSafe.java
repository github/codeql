WebSettings settings = view.getSettings();

// GOOD: WebView is configured to disallow file access
settings.setAllowFileAccess(false);
settings.setAllowFileAccessFromURLs(false);
settings.setAllowUniversalAccessFromURLs(false);
