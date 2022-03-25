import android.graphics.Bitmap;
import android.webkit.SafeBrowsingResponse;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebResourceError;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class WebViewSources {

    private static void sink(Object o) {}

    public static void test() {
        new WebViewClient() {
            // "android.webkit;WebViewClient;true;doUpdateVisitedHistory;;;Parameter[1];remote",
            @Override
            public void doUpdateVisitedHistory(WebView view, String url, boolean isReload) {
                sink(url); // $ hasValueFlow
            }

            // "android.webkit;WebViewClient;true;onLoadResource;;;Parameter[1];remote",
            @Override
            public void onLoadResource(WebView view, String url) {
                sink(url); // $ hasValueFlow
            }

            // "android.webkit;WebViewClient;true;onPageCommitVisible;;;Parameter[1];remote",
            @Override
            public void onPageCommitVisible(WebView view, String url) {
                sink(url); // $ hasValueFlow
            }

            // "android.webkit;WebViewClient;true;onPageFinished;;;Parameter[1];remote",
            @Override
            public void onPageFinished(WebView view, String url) {
                sink(url); // $ hasValueFlow
            }

            // "android.webkit;WebViewClient;true;onPageStarted;;;Parameter[1];remote",
            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {
                sink(url); // $ hasValueFlow
            }

            // "android.webkit;WebViewClient;true;onReceivedError;(WebView,int,String,String);;Parameter[3];remote",
            @Override
            public void onReceivedError(WebView view, int errorCode, String description,
                    String failingUrl) {
                sink(failingUrl); // $ hasValueFlow
            }

            // "android.webkit;WebViewClient;true;onReceivedError;(WebView,WebResourceRequest,WebResourceError);;Parameter[1];remote",
            @Override
            public void onReceivedError(WebView view, WebResourceRequest request,
                    WebResourceError error) {
                sink(request); // $ hasValueFlow
            }

            // "android.webkit;WebViewClient;true;onReceivedHttpError;;;Parameter[1];remote",
            @Override
            public void onReceivedHttpError(WebView view, WebResourceRequest request,
                    WebResourceResponse errorResponse) {
                sink(request); // $ hasValueFlow
            }

            // "android.webkit;WebViewClient;true;onSafeBrowsingHit;;;Parameter[1];remote",
            @Override
            public void onSafeBrowsingHit(WebView view, WebResourceRequest request, int threatType,
                    SafeBrowsingResponse callback) {
                sink(request); // $ hasValueFlow
            }

            // "android.webkit;WebViewClient;true;shouldInterceptRequest;;;Parameter[1];remote",
            @Override
            public WebResourceResponse shouldInterceptRequest(WebView view,
                    WebResourceRequest request) {
                sink(request); // $ hasValueFlow
                return null;
            }

            @Override
            public WebResourceResponse shouldInterceptRequest(WebView view, String url) {
                sink(url); // $ hasValueFlow
                return null;
            }

            // "android.webkit;WebViewClient;true;shouldOverrideUrlLoading;;;Parameter[1];remote"
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
                sink(request); // $ hasValueFlow
                return false;
            }

            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                sink(url); // $ hasValueFlow
                return false;
            }
        };
    }
}
