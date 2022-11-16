package com.example.test;

import android.webkit.WebView;

class WebViewAddJavascriptInterface {
    class Greeter {
    }

    public void addGreeter(WebView view) {
        view.addJavascriptInterface(new Greeter(), "greeter");
    }
}
