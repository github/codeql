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
        webview.getSettings().setAllowContentAccess(true); // $ Alert[java/android/websettings-allow-content-access]
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

        view1.getSettings().setAllowContentAccess(true); // $ Alert[java/android/websettings-allow-content-access]

        // Cast expression
        WebView view2 = (WebView) findViewById(0); // $ Alert[java/android/websettings-allow-content-access]
        settings = view2.getSettings();
        settings.setAllowContentAccess(true); // $ Alert[java/android/websettings-allow-content-access]

        // Constructor
        WebView view3 = new WebView(this); // $ Alert[java/android/websettings-allow-content-access]
        settings = view3.getSettings();
        settings.setAllowContentAccess(true); // $ Alert[java/android/websettings-allow-content-access]

        // Method access
        WebView view4 = getter.getAWebView(); // $ Alert[java/android/websettings-allow-content-access]
        settings = view4.getSettings();
        settings.setAllowContentAccess(true); // $ Alert[java/android/websettings-allow-content-access]

        enableContentAccess(getter.getAWebView()); // $ Alert[java/android/websettings-allow-content-access]

        WebView view5 = getter.getAWebView(); // $ Alert[java/android/websettings-allow-content-access]
    }
}
