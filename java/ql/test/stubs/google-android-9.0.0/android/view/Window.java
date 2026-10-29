// Generated automatically from android.view.Window for testing purposes

package android.view;

import android.content.Context;
import android.content.res.Configuration;
import android.content.res.TypedArray;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.media.session.MediaController;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.transition.Scene;
import android.transition.Transition;
import android.transition.TransitionManager;
import android.view.ActionMode;
import android.view.AttachedSurfaceControl;
import android.view.FrameMetrics;
import android.view.InputEvent;
import android.view.InputQueue;
import android.view.KeyEvent;
import android.view.KeyboardShortcutGroup;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.ScrollCaptureCallback;
import android.view.SearchEvent;
import android.view.SurfaceHolder;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowInsetsController;
import android.view.WindowManager;
import android.view.accessibility.AccessibilityEvent;
import java.util.List;

abstract public class Window
{
    protected Window() {}
    protected abstract void onActive();
    protected final boolean hasSoftInputMode(){ return false; }
    protected final int getFeatures(){ return 0; }
    protected final int getForcedWindowFlags(){ return 0; }
    protected final int getLocalFeatures(){ return 0; }
    protected static int DEFAULT_FEATURES = 0;
    protected void setDefaultWindowFormat(int p0){}
    public <T extends View> T findViewById(int p0){ return null; }
    public AttachedSurfaceControl getRootSurfaceControl(){ return null; }
    public List<Rect> getSystemGestureExclusionRects(){ return null; }
    public MediaController getMediaController(){ return null; }
    public Scene getContentScene(){ return null; }
    public Transition getEnterTransition(){ return null; }
    public Transition getExitTransition(){ return null; }
    public Transition getReenterTransition(){ return null; }
    public Transition getReturnTransition(){ return null; }
    public Transition getSharedElementEnterTransition(){ return null; }
    public Transition getSharedElementExitTransition(){ return null; }
    public Transition getSharedElementReenterTransition(){ return null; }
    public Transition getSharedElementReturnTransition(){ return null; }
    public TransitionManager getTransitionManager(){ return null; }
    public Window(Context p0){}
    public WindowInsetsController getInsetsController(){ return null; }
    public WindowManager getWindowManager(){ return null; }
    public abstract Bundle saveHierarchyState();
    public abstract LayoutInflater getLayoutInflater();
    public abstract View getCurrentFocus();
    public abstract View getDecorView();
    public abstract View peekDecorView();
    public abstract boolean isFloating();
    public abstract boolean isShortcutKey(int p0, KeyEvent p1);
    public abstract boolean performContextMenuIdentifierAction(int p0, int p1);
    public abstract boolean performPanelIdentifierAction(int p0, int p1, int p2);
    public abstract boolean performPanelShortcut(int p0, int p1, KeyEvent p2, int p3);
    public abstract boolean superDispatchGenericMotionEvent(MotionEvent p0);
    public abstract boolean superDispatchKeyEvent(KeyEvent p0);
    public abstract boolean superDispatchKeyShortcutEvent(KeyEvent p0);
    public abstract boolean superDispatchTouchEvent(MotionEvent p0);
    public abstract boolean superDispatchTrackballEvent(MotionEvent p0);
    public abstract int getNavigationBarColor();
    public abstract int getStatusBarColor();
    public abstract int getVolumeControlStream();
    public abstract void addContentView(View p0, ViewGroup.LayoutParams p1);
    public abstract void closeAllPanels();
    public abstract void closePanel(int p0);
    public abstract void invalidatePanelMenu(int p0);
    public abstract void onConfigurationChanged(Configuration p0);
    public abstract void openPanel(int p0, KeyEvent p1);
    public abstract void restoreHierarchyState(Bundle p0);
    public abstract void setBackgroundDrawable(Drawable p0);
    public abstract void setChildDrawable(int p0, Drawable p1);
    public abstract void setChildInt(int p0, int p1);
    public abstract void setContentView(View p0);
    public abstract void setContentView(View p0, ViewGroup.LayoutParams p1);
    public abstract void setContentView(int p0);
    public abstract void setDecorCaptionShade(int p0);
    public abstract void setFeatureDrawable(int p0, Drawable p1);
    public abstract void setFeatureDrawableAlpha(int p0, int p1);
    public abstract void setFeatureDrawableResource(int p0, int p1);
    public abstract void setFeatureDrawableUri(int p0, Uri p1);
    public abstract void setFeatureInt(int p0, int p1);
    public abstract void setNavigationBarColor(int p0);
    public abstract void setResizingCaptionDrawable(Drawable p0);
    public abstract void setStatusBarColor(int p0);
    public abstract void setTitle(CharSequence p0);
    public abstract void setTitleColor(int p0);
    public abstract void setVolumeControlStream(int p0);
    public abstract void takeInputQueue(InputQueue.Callback p0);
    public abstract void takeKeyEvents(boolean p0);
    public abstract void takeSurface(SurfaceHolder.Callback2 p0);
    public abstract void togglePanel(int p0, KeyEvent p1);
    public boolean getAllowEnterTransitionOverlap(){ return false; }
    public boolean getAllowReturnTransitionOverlap(){ return false; }
    public boolean getSharedElementsUseOverlay(){ return false; }
    public boolean hasFeature(int p0){ return false; }
    public boolean isNavigationBarContrastEnforced(){ return false; }
    public boolean isStatusBarContrastEnforced(){ return false; }
    public boolean isWideColorGamut(){ return false; }
    public boolean requestFeature(int p0){ return false; }
    public final <T extends View> T requireViewById(int p0){ return null; }
    public final Context getContext(){ return null; }
    public final TypedArray getWindowStyle(){ return null; }
    public final Window getContainer(){ return null; }
    public final Window.Callback getCallback(){ return null; }
    public final WindowManager.LayoutParams getAttributes(){ return null; }
    public final boolean hasChildren(){ return false; }
    public final boolean isActive(){ return false; }
    public final void addOnFrameMetricsAvailableListener(Window.OnFrameMetricsAvailableListener p0, Handler p1){}
    public final void makeActive(){}
    public final void removeOnFrameMetricsAvailableListener(Window.OnFrameMetricsAvailableListener p0){}
    public final void setHideOverlayWindows(boolean p0){}
    public final void setRestrictedCaptionAreaListener(Window.OnRestrictedCaptionAreaChangedListener p0){}
    public int getColorMode(){ return 0; }
    public int getNavigationBarDividerColor(){ return 0; }
    public long getTransitionBackgroundFadeDuration(){ return 0; }
    public static String NAVIGATION_BAR_BACKGROUND_TRANSITION_NAME = null;
    public static String STATUS_BAR_BACKGROUND_TRANSITION_NAME = null;
    public static int DECOR_CAPTION_SHADE_AUTO = 0;
    public static int DECOR_CAPTION_SHADE_DARK = 0;
    public static int DECOR_CAPTION_SHADE_LIGHT = 0;
    public static int FEATURE_ACTION_BAR = 0;
    public static int FEATURE_ACTION_BAR_OVERLAY = 0;
    public static int FEATURE_ACTION_MODE_OVERLAY = 0;
    public static int FEATURE_ACTIVITY_TRANSITIONS = 0;
    public static int FEATURE_CONTENT_TRANSITIONS = 0;
    public static int FEATURE_CONTEXT_MENU = 0;
    public static int FEATURE_CUSTOM_TITLE = 0;
    public static int FEATURE_INDETERMINATE_PROGRESS = 0;
    public static int FEATURE_LEFT_ICON = 0;
    public static int FEATURE_NO_TITLE = 0;
    public static int FEATURE_OPTIONS_PANEL = 0;
    public static int FEATURE_PROGRESS = 0;
    public static int FEATURE_RIGHT_ICON = 0;
    public static int FEATURE_SWIPE_TO_DISMISS = 0;
    public static int ID_ANDROID_CONTENT = 0;
    public static int PROGRESS_END = 0;
    public static int PROGRESS_INDETERMINATE_OFF = 0;
    public static int PROGRESS_INDETERMINATE_ON = 0;
    public static int PROGRESS_SECONDARY_END = 0;
    public static int PROGRESS_SECONDARY_START = 0;
    public static int PROGRESS_START = 0;
    public static int PROGRESS_VISIBILITY_OFF = 0;
    public static int PROGRESS_VISIBILITY_ON = 0;
    public static int getDefaultFeatures(Context p0){ return 0; }
    public void addFlags(int p0){}
    public void clearFlags(int p0){}
    public void injectInputEvent(InputEvent p0){}
    public void registerScrollCaptureCallback(ScrollCaptureCallback p0){}
    public void setAllowEnterTransitionOverlap(boolean p0){}
    public void setAllowReturnTransitionOverlap(boolean p0){}
    public void setAttributes(WindowManager.LayoutParams p0){}
    public void setBackgroundBlurRadius(int p0){}
    public void setBackgroundDrawableResource(int p0){}
    public void setCallback(Window.Callback p0){}
    public void setClipToOutline(boolean p0){}
    public void setColorMode(int p0){}
    public void setContainer(Window p0){}
    public void setDecorFitsSystemWindows(boolean p0){}
    public void setDimAmount(float p0){}
    public void setElevation(float p0){}
    public void setEnterTransition(Transition p0){}
    public void setExitTransition(Transition p0){}
    public void setFlags(int p0, int p1){}
    public void setFormat(int p0){}
    public void setGravity(int p0){}
    public void setIcon(int p0){}
    public void setLayout(int p0, int p1){}
    public void setLocalFocus(boolean p0, boolean p1){}
    public void setLogo(int p0){}
    public void setMediaController(MediaController p0){}
    public void setNavigationBarContrastEnforced(boolean p0){}
    public void setNavigationBarDividerColor(int p0){}
    public void setPreferMinimalPostProcessing(boolean p0){}
    public void setReenterTransition(Transition p0){}
    public void setReturnTransition(Transition p0){}
    public void setSharedElementEnterTransition(Transition p0){}
    public void setSharedElementExitTransition(Transition p0){}
    public void setSharedElementReenterTransition(Transition p0){}
    public void setSharedElementReturnTransition(Transition p0){}
    public void setSharedElementsUseOverlay(boolean p0){}
    public void setSoftInputMode(int p0){}
    public void setStatusBarContrastEnforced(boolean p0){}
    public void setSustainedPerformanceMode(boolean p0){}
    public void setSystemGestureExclusionRects(List<Rect> p0){}
    public void setTransitionBackgroundFadeDuration(long p0){}
    public void setTransitionManager(TransitionManager p0){}
    public void setType(int p0){}
    public void setUiOptions(int p0){}
    public void setUiOptions(int p0, int p1){}
    public void setWindowAnimations(int p0){}
    public void setWindowManager(WindowManager p0, IBinder p1, String p2){}
    public void setWindowManager(WindowManager p0, IBinder p1, String p2, boolean p3){}
    public void unregisterScrollCaptureCallback(ScrollCaptureCallback p0){}
    static public interface Callback
    {
        ActionMode onWindowStartingActionMode(ActionMode.Callback p0);
        ActionMode onWindowStartingActionMode(ActionMode.Callback p0, int p1);
        View onCreatePanelView(int p0);
        boolean dispatchGenericMotionEvent(MotionEvent p0);
        boolean dispatchKeyEvent(KeyEvent p0);
        boolean dispatchKeyShortcutEvent(KeyEvent p0);
        boolean dispatchPopulateAccessibilityEvent(AccessibilityEvent p0);
        boolean dispatchTouchEvent(MotionEvent p0);
        boolean dispatchTrackballEvent(MotionEvent p0);
        boolean onCreatePanelMenu(int p0, Menu p1);
        boolean onMenuItemSelected(int p0, MenuItem p1);
        boolean onMenuOpened(int p0, Menu p1);
        boolean onPreparePanel(int p0, View p1, Menu p2);
        boolean onSearchRequested();
        boolean onSearchRequested(SearchEvent p0);
        default void onPointerCaptureChanged(boolean p0){}
        default void onProvideKeyboardShortcuts(List<KeyboardShortcutGroup> p0, Menu p1, int p2){}
        void onActionModeFinished(ActionMode p0);
        void onActionModeStarted(ActionMode p0);
        void onAttachedToWindow();
        void onContentChanged();
        void onDetachedFromWindow();
        void onPanelClosed(int p0, Menu p1);
        void onWindowAttributesChanged(WindowManager.LayoutParams p0);
        void onWindowFocusChanged(boolean p0);
    }
    static public interface OnFrameMetricsAvailableListener
    {
        void onFrameMetricsAvailable(Window p0, FrameMetrics p1, int p2);
    }
    static public interface OnRestrictedCaptionAreaChangedListener
    {
        void onRestrictedCaptionAreaChanged(Rect p0);
    }
}
