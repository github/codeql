// Generated automatically from android.webkit.WebView for testing purposes

package android.webkit;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Picture;
import android.graphics.Rect;
import android.net.Uri;
import android.net.http.SslCertificate;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.print.PrintDocumentAdapter;
import android.util.AttributeSet;
import android.util.LongSparseArray;
import android.util.SparseArray;
import android.view.DragEvent;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewStructure;
import android.view.ViewTreeObserver;
import android.view.WindowInsets;
import android.view.accessibility.AccessibilityNodeProvider;
import android.view.autofill.AutofillId;
import android.view.autofill.AutofillValue;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputConnection;
import android.view.textclassifier.TextClassifier;
import android.view.translation.TranslationCapability;
import android.view.translation.ViewTranslationRequest;
import android.view.translation.ViewTranslationResponse;
import android.webkit.DownloadListener;
import android.webkit.ValueCallback;
import android.webkit.WebBackForwardList;
import android.webkit.WebChromeClient;
import android.webkit.WebMessage;
import android.webkit.WebMessagePort;
import android.webkit.WebSettings;
import android.webkit.WebViewClient;
import android.webkit.WebViewRenderProcess;
import android.webkit.WebViewRenderProcessClient;
import android.widget.AbsoluteLayout;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Executor;
import java.util.function.Consumer;

public class WebView extends AbsoluteLayout implements ViewGroup.OnHierarchyChangeListener, ViewTreeObserver.OnGlobalFocusChangeListener
{
    protected WebView() {}
    abstract static public class VisualStateCallback
    {
        public VisualStateCallback(){}
        public abstract void onComplete(long p0);
    }
    protected int computeHorizontalScrollOffset(){ return 0; }
    protected int computeHorizontalScrollRange(){ return 0; }
    protected int computeVerticalScrollExtent(){ return 0; }
    protected int computeVerticalScrollOffset(){ return 0; }
    protected int computeVerticalScrollRange(){ return 0; }
    protected void dispatchDraw(Canvas p0){}
    protected void onAttachedToWindow(){}
    protected void onConfigurationChanged(Configuration p0){}
    protected void onDraw(Canvas p0){}
    protected void onFocusChanged(boolean p0, int p1, Rect p2){}
    protected void onMeasure(int p0, int p1){}
    protected void onOverScrolled(int p0, int p1, boolean p2, boolean p3){}
    protected void onScrollChanged(int p0, int p1, int p2, int p3){}
    protected void onSizeChanged(int p0, int p1, int p2, int p3){}
    protected void onVisibilityChanged(View p0, int p1){}
    protected void onWindowVisibilityChanged(int p0){}
    public AccessibilityNodeProvider getAccessibilityNodeProvider(){ return null; }
    public Bitmap getFavicon(){ return null; }
    public CharSequence getAccessibilityClassName(){ return null; }
    public Handler getHandler(){ return null; }
    public InputConnection onCreateInputConnection(EditorInfo p0){ return null; }
    public Looper getWebViewLooper(){ return null; }
    public Picture capturePicture(){ return null; }
    public PrintDocumentAdapter createPrintDocumentAdapter(){ return null; }
    public PrintDocumentAdapter createPrintDocumentAdapter(String p0){ return null; }
    public SslCertificate getCertificate(){ return null; }
    public String getOriginalUrl(){ return null; }
    public String getTitle(){ return null; }
    public String getUrl(){ return null; }
    public String[] getHttpAuthUsernamePassword(String p0, String p1){ return null; }
    public TextClassifier getTextClassifier(){ return null; }
    public View findFocus(){ return null; }
    public WebBackForwardList copyBackForwardList(){ return null; }
    public WebBackForwardList restoreState(Bundle p0){ return null; }
    public WebBackForwardList saveState(Bundle p0){ return null; }
    public WebChromeClient getWebChromeClient(){ return null; }
    public WebMessagePort[] createWebMessageChannel(){ return null; }
    public WebSettings getSettings(){ return null; }
    public WebView(Context p0){}
    public WebView(Context p0, AttributeSet p1){}
    public WebView(Context p0, AttributeSet p1, int p2){}
    public WebView(Context p0, AttributeSet p1, int p2, boolean p3){}
    public WebView(Context p0, AttributeSet p1, int p2, int p3){}
    public WebView.HitTestResult getHitTestResult(){ return null; }
    public WebViewClient getWebViewClient(){ return null; }
    public WebViewRenderProcess getWebViewRenderProcess(){ return null; }
    public WebViewRenderProcessClient getWebViewRenderProcessClient(){ return null; }
    public WindowInsets onApplyWindowInsets(WindowInsets p0){ return null; }
    public boolean canGoBack(){ return false; }
    public boolean canGoBackOrForward(int p0){ return false; }
    public boolean canGoForward(){ return false; }
    public boolean canZoomIn(){ return false; }
    public boolean canZoomOut(){ return false; }
    public boolean dispatchKeyEvent(KeyEvent p0){ return false; }
    public boolean getRendererPriorityWaivedWhenNotVisible(){ return false; }
    public boolean isPrivateBrowsingEnabled(){ return false; }
    public boolean isVisibleToUserForAutofill(int p0){ return false; }
    public boolean onCheckIsTextEditor(){ return false; }
    public boolean onDragEvent(DragEvent p0){ return false; }
    public boolean onGenericMotionEvent(MotionEvent p0){ return false; }
    public boolean onHoverEvent(MotionEvent p0){ return false; }
    public boolean onKeyDown(int p0, KeyEvent p1){ return false; }
    public boolean onKeyMultiple(int p0, int p1, KeyEvent p2){ return false; }
    public boolean onKeyUp(int p0, KeyEvent p1){ return false; }
    public boolean onTouchEvent(MotionEvent p0){ return false; }
    public boolean onTrackballEvent(MotionEvent p0){ return false; }
    public boolean overlayHorizontalScrollbar(){ return false; }
    public boolean overlayVerticalScrollbar(){ return false; }
    public boolean pageDown(boolean p0){ return false; }
    public boolean pageUp(boolean p0){ return false; }
    public boolean performLongClick(){ return false; }
    public boolean requestChildRectangleOnScreen(View p0, Rect p1, boolean p2){ return false; }
    public boolean requestFocus(int p0, Rect p1){ return false; }
    public boolean shouldDelayChildPressedState(){ return false; }
    public boolean showFindDialog(String p0, boolean p1){ return false; }
    public boolean zoomIn(){ return false; }
    public boolean zoomOut(){ return false; }
    public float getScale(){ return 0; }
    public int findAll(String p0){ return 0; }
    public int getContentHeight(){ return 0; }
    public int getProgress(){ return 0; }
    public int getRendererRequestedPriority(){ return 0; }
    public static ClassLoader getWebViewClassLoader(){ return null; }
    public static PackageInfo getCurrentWebViewPackage(){ return null; }
    public static String SCHEME_GEO = null;
    public static String SCHEME_MAILTO = null;
    public static String SCHEME_TEL = null;
    public static String findAddress(String p0){ return null; }
    public static Uri getSafeBrowsingPrivacyPolicyUrl(){ return null; }
    public static int RENDERER_PRIORITY_BOUND = 0;
    public static int RENDERER_PRIORITY_IMPORTANT = 0;
    public static int RENDERER_PRIORITY_WAIVED = 0;
    public static void clearClientCertPreferences(Runnable p0){}
    public static void disableWebView(){}
    public static void enableSlowWholeDocumentDraw(){}
    public static void setDataDirectorySuffix(String p0){}
    public static void setSafeBrowsingWhitelist(List<String> p0, ValueCallback<Boolean> p1){}
    public static void setWebContentsDebuggingEnabled(boolean p0){}
    public static void startSafeBrowsing(Context p0, ValueCallback<Boolean> p1){}
    public void addJavascriptInterface(Object p0, String p1){}
    public void autofill(SparseArray<AutofillValue> p0){}
    public void clearCache(boolean p0){}
    public void clearFormData(){}
    public void clearHistory(){}
    public void clearMatches(){}
    public void clearSslPreferences(){}
    public void clearView(){}
    public void computeScroll(){}
    public void destroy(){}
    public void dispatchCreateViewTranslationRequest(Map<AutofillId, long[]> p0, int[] p1, TranslationCapability p2, List<ViewTranslationRequest> p3){}
    public void documentHasImages(Message p0){}
    public void evaluateJavascript(String p0, ValueCallback<String> p1){}
    public void findAllAsync(String p0){}
    public void findNext(boolean p0){}
    public void flingScroll(int p0, int p1){}
    public void freeMemory(){}
    public void goBack(){}
    public void goBackOrForward(int p0){}
    public void goForward(){}
    public void invokeZoomPicker(){}
    public void loadData(String p0, String p1, String p2){}
    public void loadDataWithBaseURL(String p0, String p1, String p2, String p3, String p4){}
    public void loadUrl(String p0){}
    public void loadUrl(String p0, Map<String, String> p1){}
    public void onChildViewAdded(View p0, View p1){}
    public void onChildViewRemoved(View p0, View p1){}
    public void onCreateVirtualViewTranslationRequests(long[] p0, int[] p1, Consumer<ViewTranslationRequest> p2){}
    public void onFinishTemporaryDetach(){}
    public void onGlobalFocusChanged(View p0, View p1){}
    public void onPause(){}
    public void onProvideAutofillVirtualStructure(ViewStructure p0, int p1){}
    public void onProvideContentCaptureStructure(ViewStructure p0, int p1){}
    public void onProvideVirtualStructure(ViewStructure p0){}
    public void onResume(){}
    public void onStartTemporaryDetach(){}
    public void onVirtualViewTranslationResponses(LongSparseArray<ViewTranslationResponse> p0){}
    public void onWindowFocusChanged(boolean p0){}
    public void pauseTimers(){}
    public void postUrl(String p0, byte[] p1){}
    public void postVisualStateCallback(long p0, WebView.VisualStateCallback p1){}
    public void postWebMessage(WebMessage p0, Uri p1){}
    public void reload(){}
    public void removeJavascriptInterface(String p0){}
    public void requestFocusNodeHref(Message p0){}
    public void requestImageRef(Message p0){}
    public void resumeTimers(){}
    public void savePassword(String p0, String p1, String p2){}
    public void saveWebArchive(String p0){}
    public void saveWebArchive(String p0, boolean p1, ValueCallback<String> p2){}
    public void setBackgroundColor(int p0){}
    public void setCertificate(SslCertificate p0){}
    public void setDownloadListener(DownloadListener p0){}
    public void setFindListener(WebView.FindListener p0){}
    public void setHorizontalScrollbarOverlay(boolean p0){}
    public void setHttpAuthUsernamePassword(String p0, String p1, String p2, String p3){}
    public void setInitialScale(int p0){}
    public void setLayerType(int p0, Paint p1){}
    public void setLayoutParams(ViewGroup.LayoutParams p0){}
    public void setMapTrackballToArrowKeys(boolean p0){}
    public void setNetworkAvailable(boolean p0){}
    public void setOverScrollMode(int p0){}
    public void setPictureListener(WebView.PictureListener p0){}
    public void setRendererPriorityPolicy(int p0, boolean p1){}
    public void setScrollBarStyle(int p0){}
    public void setTextClassifier(TextClassifier p0){}
    public void setVerticalScrollbarOverlay(boolean p0){}
    public void setWebChromeClient(WebChromeClient p0){}
    public void setWebViewClient(WebViewClient p0){}
    public void setWebViewRenderProcessClient(Executor p0, WebViewRenderProcessClient p1){}
    public void setWebViewRenderProcessClient(WebViewRenderProcessClient p0){}
    public void stopLoading(){}
    public void zoomBy(float p0){}
    static public class HitTestResult
    {
        public String getExtra(){ return null; }
        public int getType(){ return 0; }
        public static int ANCHOR_TYPE = 0;
        public static int EDIT_TEXT_TYPE = 0;
        public static int EMAIL_TYPE = 0;
        public static int GEO_TYPE = 0;
        public static int IMAGE_ANCHOR_TYPE = 0;
        public static int IMAGE_TYPE = 0;
        public static int PHONE_TYPE = 0;
        public static int SRC_ANCHOR_TYPE = 0;
        public static int SRC_IMAGE_ANCHOR_TYPE = 0;
        public static int UNKNOWN_TYPE = 0;
    }
    static public interface FindListener
    {
        void onFindResultReceived(int p0, int p1, boolean p2);
    }
    static public interface PictureListener
    {
        void onNewPicture(WebView p0, Picture p1);
    }
}
