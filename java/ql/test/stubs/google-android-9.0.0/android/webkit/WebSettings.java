// Generated automatically from android.webkit.WebSettings for testing purposes

package android.webkit;

import android.content.Context;

abstract public class WebSettings
{
    public WebSettings(){}
    public WebSettings.TextSize getTextSize(){ return null; }
    public abstract String getCursiveFontFamily();
    public abstract String getDatabasePath();
    public abstract String getDefaultTextEncodingName();
    public abstract String getFantasyFontFamily();
    public abstract String getFixedFontFamily();
    public abstract String getSansSerifFontFamily();
    public abstract String getSerifFontFamily();
    public abstract String getStandardFontFamily();
    public abstract String getUserAgentString();
    public abstract WebSettings.LayoutAlgorithm getLayoutAlgorithm();
    public abstract WebSettings.PluginState getPluginState();
    public abstract WebSettings.ZoomDensity getDefaultZoom();
    public abstract boolean enableSmoothTransition();
    public abstract boolean getAllowContentAccess();
    public abstract boolean getAllowFileAccess();
    public abstract boolean getAllowFileAccessFromFileURLs();
    public abstract boolean getAllowUniversalAccessFromFileURLs();
    public abstract boolean getBlockNetworkImage();
    public abstract boolean getBlockNetworkLoads();
    public abstract boolean getBuiltInZoomControls();
    public abstract boolean getDatabaseEnabled();
    public abstract boolean getDisplayZoomControls();
    public abstract boolean getDomStorageEnabled();
    public abstract boolean getJavaScriptCanOpenWindowsAutomatically();
    public abstract boolean getJavaScriptEnabled();
    public abstract boolean getLightTouchEnabled();
    public abstract boolean getLoadWithOverviewMode();
    public abstract boolean getLoadsImagesAutomatically();
    public abstract boolean getMediaPlaybackRequiresUserGesture();
    public abstract boolean getOffscreenPreRaster();
    public abstract boolean getSafeBrowsingEnabled();
    public abstract boolean getSaveFormData();
    public abstract boolean getSavePassword();
    public abstract boolean getUseWideViewPort();
    public abstract boolean supportMultipleWindows();
    public abstract boolean supportZoom();
    public abstract int getCacheMode();
    public abstract int getDefaultFixedFontSize();
    public abstract int getDefaultFontSize();
    public abstract int getDisabledActionModeMenuItems();
    public abstract int getMinimumFontSize();
    public abstract int getMinimumLogicalFontSize();
    public abstract int getMixedContentMode();
    public abstract int getTextZoom();
    public abstract void setAllowContentAccess(boolean p0);
    public abstract void setAllowFileAccess(boolean p0);
    public abstract void setAllowFileAccessFromFileURLs(boolean p0);
    public abstract void setAllowUniversalAccessFromFileURLs(boolean p0);
    public abstract void setAppCacheEnabled(boolean p0);
    public abstract void setAppCacheMaxSize(long p0);
    public abstract void setAppCachePath(String p0);
    public abstract void setBlockNetworkImage(boolean p0);
    public abstract void setBlockNetworkLoads(boolean p0);
    public abstract void setBuiltInZoomControls(boolean p0);
    public abstract void setCacheMode(int p0);
    public abstract void setCursiveFontFamily(String p0);
    public abstract void setDatabaseEnabled(boolean p0);
    public abstract void setDatabasePath(String p0);
    public abstract void setDefaultFixedFontSize(int p0);
    public abstract void setDefaultFontSize(int p0);
    public abstract void setDefaultTextEncodingName(String p0);
    public abstract void setDefaultZoom(WebSettings.ZoomDensity p0);
    public abstract void setDisabledActionModeMenuItems(int p0);
    public abstract void setDisplayZoomControls(boolean p0);
    public abstract void setDomStorageEnabled(boolean p0);
    public abstract void setEnableSmoothTransition(boolean p0);
    public abstract void setFantasyFontFamily(String p0);
    public abstract void setFixedFontFamily(String p0);
    public abstract void setGeolocationDatabasePath(String p0);
    public abstract void setGeolocationEnabled(boolean p0);
    public abstract void setJavaScriptCanOpenWindowsAutomatically(boolean p0);
    public abstract void setJavaScriptEnabled(boolean p0);
    public abstract void setLayoutAlgorithm(WebSettings.LayoutAlgorithm p0);
    public abstract void setLightTouchEnabled(boolean p0);
    public abstract void setLoadWithOverviewMode(boolean p0);
    public abstract void setLoadsImagesAutomatically(boolean p0);
    public abstract void setMediaPlaybackRequiresUserGesture(boolean p0);
    public abstract void setMinimumFontSize(int p0);
    public abstract void setMinimumLogicalFontSize(int p0);
    public abstract void setMixedContentMode(int p0);
    public abstract void setNeedInitialFocus(boolean p0);
    public abstract void setOffscreenPreRaster(boolean p0);
    public abstract void setPluginState(WebSettings.PluginState p0);
    public abstract void setRenderPriority(WebSettings.RenderPriority p0);
    public abstract void setSafeBrowsingEnabled(boolean p0);
    public abstract void setSansSerifFontFamily(String p0);
    public abstract void setSaveFormData(boolean p0);
    public abstract void setSavePassword(boolean p0);
    public abstract void setSerifFontFamily(String p0);
    public abstract void setStandardFontFamily(String p0);
    public abstract void setSupportMultipleWindows(boolean p0);
    public abstract void setSupportZoom(boolean p0);
    public abstract void setTextZoom(int p0);
    public abstract void setUseWideViewPort(boolean p0);
    public abstract void setUserAgentString(String p0);
    public int getForceDark(){ return 0; }
    public static String getDefaultUserAgent(Context p0){ return null; }
    public static int FORCE_DARK_AUTO = 0;
    public static int FORCE_DARK_OFF = 0;
    public static int FORCE_DARK_ON = 0;
    public static int LOAD_CACHE_ELSE_NETWORK = 0;
    public static int LOAD_CACHE_ONLY = 0;
    public static int LOAD_DEFAULT = 0;
    public static int LOAD_NORMAL = 0;
    public static int LOAD_NO_CACHE = 0;
    public static int MENU_ITEM_NONE = 0;
    public static int MENU_ITEM_PROCESS_TEXT = 0;
    public static int MENU_ITEM_SHARE = 0;
    public static int MENU_ITEM_WEB_SEARCH = 0;
    public static int MIXED_CONTENT_ALWAYS_ALLOW = 0;
    public static int MIXED_CONTENT_COMPATIBILITY_MODE = 0;
    public static int MIXED_CONTENT_NEVER_ALLOW = 0;
    public void setForceDark(int p0){}
    public void setTextSize(WebSettings.TextSize p0){}
    static public enum LayoutAlgorithm
    {
        NARROW_COLUMNS, NORMAL, SINGLE_COLUMN, TEXT_AUTOSIZING;
        private LayoutAlgorithm() {}
    }
    static public enum PluginState
    {
        OFF, ON, ON_DEMAND;
        private PluginState() {}
    }
    static public enum RenderPriority
    {
        HIGH, LOW, NORMAL;
        private RenderPriority() {}
    }
    static public enum TextSize
    {
        LARGER, LARGEST, NORMAL, SMALLER, SMALLEST;
        private TextSize() {}
    }
    static public enum ZoomDensity
    {
        CLOSE, FAR, MEDIUM;
        private ZoomDensity() {}
    }
}
