package com.example.test;

import android.webkit.WebView;
import android.webkit.WebSettings;

public class SetJavascriptEnabled {
    public static void configureWebViewUnsafe(WebView view) {
        WebSettings settings = view.getSettings();
        settings.setJavaScriptEnabled(true); // $javascriptEnabled
    }

    public static void configureWebViewSafe(WebView view) {
        WebSettings settings = view.getSettings();

        // Safe: Javascript disabled
        settings.setJavaScriptEnabled(false);
    }
}
