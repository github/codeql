// Generated automatically from android.webkit.WebChromeClient for testing purposes

package android.webkit;

import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Message;
import android.view.View;
import android.webkit.ConsoleMessage;
import android.webkit.GeolocationPermissions;
import android.webkit.JsPromptResult;
import android.webkit.JsResult;
import android.webkit.PermissionRequest;
import android.webkit.ValueCallback;
import android.webkit.WebStorage;
import android.webkit.WebView;

public class WebChromeClient
{
    abstract static public class FileChooserParams
    {
        public FileChooserParams(){}
        public abstract CharSequence getTitle();
        public abstract Intent createIntent();
        public abstract String getFilenameHint();
        public abstract String[] getAcceptTypes();
        public abstract boolean isCaptureEnabled();
        public abstract int getMode();
        public static Uri[] parseResult(int p0, Intent p1){ return null; }
        public static int MODE_OPEN = 0;
        public static int MODE_OPEN_MULTIPLE = 0;
        public static int MODE_SAVE = 0;
    }
    public Bitmap getDefaultVideoPoster(){ return null; }
    public View getVideoLoadingProgressView(){ return null; }
    public WebChromeClient(){}
    public boolean onConsoleMessage(ConsoleMessage p0){ return false; }
    public boolean onCreateWindow(WebView p0, boolean p1, boolean p2, Message p3){ return false; }
    public boolean onJsAlert(WebView p0, String p1, String p2, JsResult p3){ return false; }
    public boolean onJsBeforeUnload(WebView p0, String p1, String p2, JsResult p3){ return false; }
    public boolean onJsConfirm(WebView p0, String p1, String p2, JsResult p3){ return false; }
    public boolean onJsPrompt(WebView p0, String p1, String p2, String p3, JsPromptResult p4){ return false; }
    public boolean onJsTimeout(){ return false; }
    public boolean onShowFileChooser(WebView p0, ValueCallback<Uri[]> p1, WebChromeClient.FileChooserParams p2){ return false; }
    public void getVisitedHistory(ValueCallback<String[]> p0){}
    public void onCloseWindow(WebView p0){}
    public void onConsoleMessage(String p0, int p1, String p2){}
    public void onExceededDatabaseQuota(String p0, String p1, long p2, long p3, long p4, WebStorage.QuotaUpdater p5){}
    public void onGeolocationPermissionsHidePrompt(){}
    public void onGeolocationPermissionsShowPrompt(String p0, GeolocationPermissions.Callback p1){}
    public void onHideCustomView(){}
    public void onPermissionRequest(PermissionRequest p0){}
    public void onPermissionRequestCanceled(PermissionRequest p0){}
    public void onProgressChanged(WebView p0, int p1){}
    public void onReachedMaxAppCacheSize(long p0, long p1, WebStorage.QuotaUpdater p2){}
    public void onReceivedIcon(WebView p0, Bitmap p1){}
    public void onReceivedTitle(WebView p0, String p1){}
    public void onReceivedTouchIconUrl(WebView p0, String p1, boolean p2){}
    public void onRequestFocus(WebView p0){}
    public void onShowCustomView(View p0, WebChromeClient.CustomViewCallback p1){}
    public void onShowCustomView(View p0, int p1, WebChromeClient.CustomViewCallback p2){}
    static public interface CustomViewCallback
    {
        void onCustomViewHidden();
    }
}
