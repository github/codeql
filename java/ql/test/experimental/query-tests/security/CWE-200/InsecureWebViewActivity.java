package com.example.app;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Locale;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import android.webkit.MimeTypeMap;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.webkit.WebResourceResponse;

/** Insecure WebView activity with its subclassed webview implementation. */
public class InsecureWebViewActivity extends Activity {
    VulnerableWebView webview;

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(-1);
        webview = (VulnerableWebView) findViewById(-1);

        String inputUrl = getIntent().getStringExtra("inputUrl");
        loadWebUrl(inputUrl);
    }

    public static String getMimeTypeFromPath(String path) {
        String extension = path;
        int lastDot = extension.lastIndexOf('.');
        if (lastDot != -1) {
            extension = extension.substring(lastDot + 1);
        }

        extension = extension.toLowerCase(Locale.getDefault());
        return MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension);
    }

    public void loadWebUrl(String url) {
        webview.loadUrl(url);
    }
}

class VulnerableWebView extends WebView {
    public VulnerableWebView(Context context) {
        super(context);

        this.setWebViewClient(new WebViewClient() {
            @Override
            public WebResourceResponse shouldInterceptRequest(WebView view, String url) {
                try {
                    Uri uri = Uri.parse(url);
                    FileInputStream inputStream = new FileInputStream(uri.getPath());
                    String mimeType = InsecureWebViewActivity.getMimeTypeFromPath(uri.getPath());
                    return new WebResourceResponse(mimeType, "UTF-8", inputStream);
                } catch (IOException ie) {
                    return new WebResourceResponse("text/plain", "UTF-8", null);
                }
            }
        });
    }
}
