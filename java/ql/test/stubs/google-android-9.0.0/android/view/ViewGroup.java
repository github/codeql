// Generated automatically from android.view.ViewGroup for testing purposes

package android.view;

import android.animation.LayoutTransition;
import android.content.Context;
import android.content.res.Configuration;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Point;
import android.graphics.Rect;
import android.graphics.Region;
import android.os.Bundle;
import android.os.Parcelable;
import android.util.AttributeSet;
import android.util.SparseArray;
import android.view.ActionMode;
import android.view.DragEvent;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.PointerIcon;
import android.view.ScrollCaptureTarget;
import android.view.View;
import android.view.ViewGroupOverlay;
import android.view.ViewManager;
import android.view.ViewParent;
import android.view.ViewStructure;
import android.view.WindowInsets;
import android.view.WindowInsetsAnimation;
import android.view.accessibility.AccessibilityEvent;
import android.view.accessibility.AccessibilityNodeInfo;
import android.view.animation.Animation;
import android.view.animation.LayoutAnimationController;
import android.view.animation.Transformation;
import android.view.autofill.AutofillId;
import android.view.translation.TranslationCapability;
import android.view.translation.ViewTranslationRequest;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.function.Consumer;

abstract public class ViewGroup extends View implements ViewManager, ViewParent
{
    protected ViewGroup() {}
    protected ViewGroup.LayoutParams generateDefaultLayoutParams(){ return null; }
    protected ViewGroup.LayoutParams generateLayoutParams(ViewGroup.LayoutParams p0){ return null; }
    protected abstract void onLayout(boolean p0, int p1, int p2, int p3, int p4);
    protected boolean addViewInLayout(View p0, int p1, ViewGroup.LayoutParams p2){ return false; }
    protected boolean addViewInLayout(View p0, int p1, ViewGroup.LayoutParams p2, boolean p3){ return false; }
    protected boolean canAnimate(){ return false; }
    protected boolean checkLayoutParams(ViewGroup.LayoutParams p0){ return false; }
    protected boolean dispatchGenericFocusedEvent(MotionEvent p0){ return false; }
    protected boolean dispatchGenericPointerEvent(MotionEvent p0){ return false; }
    protected boolean dispatchHoverEvent(MotionEvent p0){ return false; }
    protected boolean drawChild(Canvas p0, View p1, long p2){ return false; }
    protected boolean getChildStaticTransformation(View p0, Transformation p1){ return false; }
    protected boolean isChildrenDrawingOrderEnabled(){ return false; }
    protected boolean isChildrenDrawnWithCacheEnabled(){ return false; }
    protected boolean onRequestFocusInDescendants(int p0, Rect p1){ return false; }
    protected int getChildDrawingOrder(int p0, int p1){ return 0; }
    protected int[] onCreateDrawableState(int p0){ return null; }
    protected static int CLIP_TO_PADDING_MASK = 0;
    protected void attachLayoutAnimationParameters(View p0, ViewGroup.LayoutParams p1, int p2, int p3){}
    protected void attachViewToParent(View p0, int p1, ViewGroup.LayoutParams p2){}
    protected void cleanupLayoutState(View p0){}
    protected void debug(int p0){}
    protected void detachAllViewsFromParent(){}
    protected void detachViewFromParent(View p0){}
    protected void detachViewFromParent(int p0){}
    protected void detachViewsFromParent(int p0, int p1){}
    protected void dispatchDraw(Canvas p0){}
    protected void dispatchFreezeSelfOnly(SparseArray<Parcelable> p0){}
    protected void dispatchRestoreInstanceState(SparseArray<Parcelable> p0){}
    protected void dispatchSaveInstanceState(SparseArray<Parcelable> p0){}
    protected void dispatchSetPressed(boolean p0){}
    protected void dispatchThawSelfOnly(SparseArray<Parcelable> p0){}
    protected void dispatchVisibilityChanged(View p0, int p1){}
    protected void drawableStateChanged(){}
    protected void measureChild(View p0, int p1, int p2){}
    protected void measureChildWithMargins(View p0, int p1, int p2, int p3, int p4){}
    protected void measureChildren(int p0, int p1){}
    protected void onAttachedToWindow(){}
    protected void onDetachedFromWindow(){}
    protected void removeDetachedView(View p0, boolean p1){}
    protected void setChildrenDrawingCacheEnabled(boolean p0){}
    protected void setChildrenDrawingOrderEnabled(boolean p0){}
    protected void setChildrenDrawnWithCacheEnabled(boolean p0){}
    protected void setStaticTransformationsEnabled(boolean p0){}
    public ActionMode startActionModeForChild(View p0, ActionMode.Callback p1){ return null; }
    public ActionMode startActionModeForChild(View p0, ActionMode.Callback p1, int p2){ return null; }
    public Animation.AnimationListener getLayoutAnimationListener(){ return null; }
    public CharSequence getAccessibilityClassName(){ return null; }
    public LayoutAnimationController getLayoutAnimation(){ return null; }
    public LayoutTransition getLayoutTransition(){ return null; }
    public PointerIcon onResolvePointerIcon(MotionEvent p0, int p1){ return null; }
    public View findFocus(){ return null; }
    public View focusSearch(View p0, int p1){ return null; }
    public View getChildAt(int p0){ return null; }
    public View getFocusedChild(){ return null; }
    public ViewGroup(Context p0){}
    public ViewGroup(Context p0, AttributeSet p1){}
    public ViewGroup(Context p0, AttributeSet p1, int p2){}
    public ViewGroup(Context p0, AttributeSet p1, int p2, int p3){}
    public ViewGroup.LayoutParams generateLayoutParams(AttributeSet p0){ return null; }
    public ViewGroupOverlay getOverlay(){ return null; }
    public ViewParent invalidateChildInParent(int[] p0, Rect p1){ return null; }
    public WindowInsets dispatchApplyWindowInsets(WindowInsets p0){ return null; }
    public WindowInsets dispatchWindowInsetsAnimationProgress(WindowInsets p0, List<WindowInsetsAnimation> p1){ return null; }
    public WindowInsetsAnimation.Bounds dispatchWindowInsetsAnimationStart(WindowInsetsAnimation p0, WindowInsetsAnimation.Bounds p1){ return null; }
    public boolean addStatesFromChildren(){ return false; }
    public boolean dispatchCapturedPointerEvent(MotionEvent p0){ return false; }
    public boolean dispatchDragEvent(DragEvent p0){ return false; }
    public boolean dispatchKeyEvent(KeyEvent p0){ return false; }
    public boolean dispatchKeyEventPreIme(KeyEvent p0){ return false; }
    public boolean dispatchKeyShortcutEvent(KeyEvent p0){ return false; }
    public boolean dispatchTouchEvent(MotionEvent p0){ return false; }
    public boolean dispatchTrackballEvent(MotionEvent p0){ return false; }
    public boolean dispatchUnhandledMove(View p0, int p1){ return false; }
    public boolean gatherTransparentRegion(Region p0){ return false; }
    public boolean getChildVisibleRect(View p0, Rect p1, Point p2){ return false; }
    public boolean getClipChildren(){ return false; }
    public boolean getClipToPadding(){ return false; }
    public boolean getTouchscreenBlocksFocus(){ return false; }
    public boolean hasFocus(){ return false; }
    public boolean hasTransientState(){ return false; }
    public boolean isAlwaysDrawnWithCacheEnabled(){ return false; }
    public boolean isAnimationCacheEnabled(){ return false; }
    public boolean isLayoutSuppressed(){ return false; }
    public boolean isMotionEventSplittingEnabled(){ return false; }
    public boolean isTransitionGroup(){ return false; }
    public boolean onInterceptHoverEvent(MotionEvent p0){ return false; }
    public boolean onInterceptTouchEvent(MotionEvent p0){ return false; }
    public boolean onNestedFling(View p0, float p1, float p2, boolean p3){ return false; }
    public boolean onNestedPreFling(View p0, float p1, float p2){ return false; }
    public boolean onNestedPrePerformAccessibilityAction(View p0, int p1, Bundle p2){ return false; }
    public boolean onRequestSendAccessibilityEvent(View p0, AccessibilityEvent p1){ return false; }
    public boolean onStartNestedScroll(View p0, View p1, int p2){ return false; }
    public boolean requestChildRectangleOnScreen(View p0, Rect p1, boolean p2){ return false; }
    public boolean requestFocus(int p0, Rect p1){ return false; }
    public boolean requestSendAccessibilityEvent(View p0, AccessibilityEvent p1){ return false; }
    public boolean restoreDefaultFocus(){ return false; }
    public boolean shouldDelayChildPressedState(){ return false; }
    public boolean showContextMenuForChild(View p0){ return false; }
    public boolean showContextMenuForChild(View p0, float p1, float p2){ return false; }
    public final int getChildDrawingOrder(int p0){ return 0; }
    public final void invalidateChild(View p0, Rect p1){}
    public final void layout(int p0, int p1, int p2, int p3){}
    public final void offsetDescendantRectToMyCoords(View p0, Rect p1){}
    public final void offsetRectIntoDescendantCoords(View p0, Rect p1){}
    public int getChildCount(){ return 0; }
    public int getDescendantFocusability(){ return 0; }
    public int getLayoutMode(){ return 0; }
    public int getNestedScrollAxes(){ return 0; }
    public int getPersistentDrawingCache(){ return 0; }
    public int indexOfChild(View p0){ return 0; }
    public static int FOCUS_AFTER_DESCENDANTS = 0;
    public static int FOCUS_BEFORE_DESCENDANTS = 0;
    public static int FOCUS_BLOCK_DESCENDANTS = 0;
    public static int LAYOUT_MODE_CLIP_BOUNDS = 0;
    public static int LAYOUT_MODE_OPTICAL_BOUNDS = 0;
    public static int PERSISTENT_ALL_CACHES = 0;
    public static int PERSISTENT_ANIMATION_CACHE = 0;
    public static int PERSISTENT_NO_CACHE = 0;
    public static int PERSISTENT_SCROLLING_CACHE = 0;
    public static int getChildMeasureSpec(int p0, int p1, int p2){ return 0; }
    public void addChildrenForAccessibility(ArrayList<View> p0){}
    public void addExtraDataToAccessibilityNodeInfo(AccessibilityNodeInfo p0, String p1, Bundle p2){}
    public void addFocusables(ArrayList<View> p0, int p1, int p2){}
    public void addKeyboardNavigationClusters(Collection<View> p0, int p1){}
    public void addTouchables(ArrayList<View> p0){}
    public void addView(View p0){}
    public void addView(View p0, ViewGroup.LayoutParams p1){}
    public void addView(View p0, int p1){}
    public void addView(View p0, int p1, ViewGroup.LayoutParams p2){}
    public void addView(View p0, int p1, int p2){}
    public void bringChildToFront(View p0){}
    public void childDrawableStateChanged(View p0){}
    public void childHasTransientStateChanged(View p0, boolean p1){}
    public void clearChildFocus(View p0){}
    public void clearDisappearingChildren(){}
    public void clearFocus(){}
    public void dispatchConfigurationChanged(Configuration p0){}
    public void dispatchCreateViewTranslationRequest(Map<AutofillId, long[]> p0, int[] p1, TranslationCapability p2, List<ViewTranslationRequest> p3){}
    public void dispatchDisplayHint(int p0){}
    public void dispatchDrawableHotspotChanged(float p0, float p1){}
    public void dispatchFinishTemporaryDetach(){}
    public void dispatchPointerCaptureChanged(boolean p0){}
    public void dispatchProvideAutofillStructure(ViewStructure p0, int p1){}
    public void dispatchProvideStructure(ViewStructure p0){}
    public void dispatchScrollCaptureSearch(Rect p0, Point p1, Consumer<ScrollCaptureTarget> p2){}
    public void dispatchSetActivated(boolean p0){}
    public void dispatchSetSelected(boolean p0){}
    public void dispatchStartTemporaryDetach(){}
    public void dispatchSystemUiVisibilityChanged(int p0){}
    public void dispatchWindowFocusChanged(boolean p0){}
    public void dispatchWindowInsetsAnimationEnd(WindowInsetsAnimation p0){}
    public void dispatchWindowInsetsAnimationPrepare(WindowInsetsAnimation p0){}
    public void dispatchWindowSystemUiVisiblityChanged(int p0){}
    public void dispatchWindowVisibilityChanged(int p0){}
    public void endViewTransition(View p0){}
    public void findViewsWithText(ArrayList<View> p0, CharSequence p1, int p2){}
    public void focusableViewAvailable(View p0){}
    public void jumpDrawablesToCurrentState(){}
    public void notifySubtreeAccessibilityStateChanged(View p0, View p1, int p2){}
    public void onDescendantInvalidated(View p0, View p1){}
    public void onNestedPreScroll(View p0, int p1, int p2, int[] p3){}
    public void onNestedScroll(View p0, int p1, int p2, int p3, int p4){}
    public void onNestedScrollAccepted(View p0, View p1, int p2){}
    public void onStopNestedScroll(View p0){}
    public void onViewAdded(View p0){}
    public void onViewRemoved(View p0){}
    public void recomputeViewAttributes(View p0){}
    public void removeAllViews(){}
    public void removeAllViewsInLayout(){}
    public void removeView(View p0){}
    public void removeViewAt(int p0){}
    public void removeViewInLayout(View p0){}
    public void removeViews(int p0, int p1){}
    public void removeViewsInLayout(int p0, int p1){}
    public void requestChildFocus(View p0, View p1){}
    public void requestDisallowInterceptTouchEvent(boolean p0){}
    public void requestTransparentRegion(View p0){}
    public void scheduleLayoutAnimation(){}
    public void setAddStatesFromChildren(boolean p0){}
    public void setAlwaysDrawnWithCacheEnabled(boolean p0){}
    public void setAnimationCacheEnabled(boolean p0){}
    public void setClipChildren(boolean p0){}
    public void setClipToPadding(boolean p0){}
    public void setDescendantFocusability(int p0){}
    public void setLayoutAnimation(LayoutAnimationController p0){}
    public void setLayoutAnimationListener(Animation.AnimationListener p0){}
    public void setLayoutMode(int p0){}
    public void setLayoutTransition(LayoutTransition p0){}
    public void setMotionEventSplittingEnabled(boolean p0){}
    public void setOnHierarchyChangeListener(ViewGroup.OnHierarchyChangeListener p0){}
    public void setPersistentDrawingCache(int p0){}
    public void setTouchscreenBlocksFocus(boolean p0){}
    public void setTransitionGroup(boolean p0){}
    public void setWindowInsetsAnimationCallback(WindowInsetsAnimation.Callback p0){}
    public void startLayoutAnimation(){}
    public void startViewTransition(View p0){}
    public void suppressLayout(boolean p0){}
    public void updateViewLayout(View p0, ViewGroup.LayoutParams p1){}
    static public class LayoutParams
    {
        protected LayoutParams() {}
        protected void setBaseAttributes(TypedArray p0, int p1, int p2){}
        public LayoutAnimationController.AnimationParameters layoutAnimationParameters = null;
        public LayoutParams(Context p0, AttributeSet p1){}
        public LayoutParams(ViewGroup.LayoutParams p0){}
        public LayoutParams(int p0, int p1){}
        public int height = 0;
        public int width = 0;
        public static int FILL_PARENT = 0;
        public static int MATCH_PARENT = 0;
        public static int WRAP_CONTENT = 0;
        public void resolveLayoutDirection(int p0){}
    }
    static public interface OnHierarchyChangeListener
    {
        void onChildViewAdded(View p0, View p1);
        void onChildViewRemoved(View p0, View p1);
    }
}
