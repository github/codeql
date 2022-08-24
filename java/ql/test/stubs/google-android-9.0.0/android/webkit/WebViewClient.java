// Generated automatically from android.webkit.WebViewClient for testing purposes

package android.webkit;

import android.graphics.Bitmap;
import android.net.http.SslError;
import android.os.Message;
import android.view.KeyEvent;
import android.webkit.ClientCertRequest;
import android.webkit.HttpAuthHandler;
import android.webkit.RenderProcessGoneDetail;
import android.webkit.SafeBrowsingResponse;
import android.webkit.SslErrorHandler;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;

public class WebViewClient
{
    public WebResourceResponse shouldInterceptRequest(WebView p0, String p1){ return null; }
    public WebResourceResponse shouldInterceptRequest(WebView p0, WebResourceRequest p1){ return null; }
    public WebViewClient(){}
    public boolean onRenderProcessGone(WebView p0, RenderProcessGoneDetail p1){ return false; }
    public boolean shouldOverrideKeyEvent(WebView p0, KeyEvent p1){ return false; }
    public boolean shouldOverrideUrlLoading(WebView p0, String p1){ return false; }
    public boolean shouldOverrideUrlLoading(WebView p0, WebResourceRequest p1){ return false; }
    public static int ERROR_AUTHENTICATION = 0;
    public static int ERROR_BAD_URL = 0;
    public static int ERROR_CONNECT = 0;
    public static int ERROR_FAILED_SSL_HANDSHAKE = 0;
    public static int ERROR_FILE = 0;
    public static int ERROR_FILE_NOT_FOUND = 0;
    public static int ERROR_HOST_LOOKUP = 0;
    public static int ERROR_IO = 0;
    public static int ERROR_PROXY_AUTHENTICATION = 0;
    public static int ERROR_REDIRECT_LOOP = 0;
    public static int ERROR_TIMEOUT = 0;
    public static int ERROR_TOO_MANY_REQUESTS = 0;
    public static int ERROR_UNKNOWN = 0;
    public static int ERROR_UNSAFE_RESOURCE = 0;
    public static int ERROR_UNSUPPORTED_AUTH_SCHEME = 0;
    public static int ERROR_UNSUPPORTED_SCHEME = 0;
    public static int SAFE_BROWSING_THREAT_BILLING = 0;
    public static int SAFE_BROWSING_THREAT_MALWARE = 0;
    public static int SAFE_BROWSING_THREAT_PHISHING = 0;
    public static int SAFE_BROWSING_THREAT_UNKNOWN = 0;
    public static int SAFE_BROWSING_THREAT_UNWANTED_SOFTWARE = 0;
    public void doUpdateVisitedHistory(WebView p0, String p1, boolean p2){}
    public void onFormResubmission(WebView p0, Message p1, Message p2){}
    public void onLoadResource(WebView p0, String p1){}
    public void onPageCommitVisible(WebView p0, String p1){}
    public void onPageFinished(WebView p0, String p1){}
    public void onPageStarted(WebView p0, String p1, Bitmap p2){}
    public void onReceivedClientCertRequest(WebView p0, ClientCertRequest p1){}
    public void onReceivedError(WebView p0, WebResourceRequest p1, WebResourceError p2){}
    public void onReceivedError(WebView p0, int p1, String p2, String p3){}
    public void onReceivedHttpAuthRequest(WebView p0, HttpAuthHandler p1, String p2, String p3){}
    public void onReceivedHttpError(WebView p0, WebResourceRequest p1, WebResourceResponse p2){}
    public void onReceivedLoginRequest(WebView p0, String p1, String p2, String p3){}
    public void onReceivedSslError(WebView p0, SslErrorHandler p1, SslError p2){}
    public void onSafeBrowsingHit(WebView p0, WebResourceRequest p1, int p2, SafeBrowsingResponse p3){}
    public void onScaleChanged(WebView p0, float p1, float p2){}
    public void onTooManyRedirects(WebView p0, Message p1, Message p2){}
    public void onUnhandledKeyEvent(WebView p0, KeyEvent p1){}
}
