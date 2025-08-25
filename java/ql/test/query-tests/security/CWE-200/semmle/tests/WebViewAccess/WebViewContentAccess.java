package com.example.test;

import android.app.Activity;

import android.webkit.WebView;
import android.webkit.WebSettings;

/** Helper class to mock a method which returns a `WebView` */
interface WebViewGetter {
    WebView getAWebView();
}

public class WebViewContentAccess extends Activity {
    void enableContentAccess(WebView webview) {
        webview.getSettings().setAllowContentAccess(true);
    }

    void disableContentAccess(WebView webview) {
        webview.getSettings().setAllowContentAccess(false);
    }

    void configureWebViewSafe(WebView view, WebViewGetter getter) {
        WebSettings settings = view.getSettings();

        settings.setAllowContentAccess(false);

        WebView view2 = (WebView) findViewById(0);
        settings = view2.getSettings();

        settings.setAllowContentAccess(false);

        disableContentAccess(getter.getAWebView());
    }

    void configureWebViewUnsafe(WebView view1, WebViewGetter getter) {
        WebSettings settings;

        view1.getSettings().setAllowContentAccess(true);

        // Cast expression
        WebView view2 = (WebView) findViewById(0);
        settings = view2.getSettings();
        settings.setAllowContentAccess(true);

        // Constructor
        WebView view3 = new WebView(this);
        settings = view3.getSettings();
        settings.setAllowContentAccess(true);

        // Method access
        WebView view4 = getter.getAWebView();
        settings = view4.getSettings();
        settings.setAllowContentAccess(true);

        enableContentAccess(getter.getAWebView());

        WebView view5 = getter.getAWebView();
    }
}
