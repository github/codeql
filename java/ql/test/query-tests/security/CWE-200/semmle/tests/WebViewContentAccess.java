package com.example.test;

import android.webkit.WebView;
import android.webkit.WebSettings;

public class WebViewContentAccess {
    void configureWebViewUnsafe(WebView view) {
        WebSettings settings = view.getSettings();

        settings.setAllowContentAccess(true);
    }

    void configureWebViewSafe(WebView view) {
        WebSettings settings = view.getSettings();

        settings.setAllowContentAccess(false);
    }
}
