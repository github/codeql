// Generated automatically from android.view.View for testing purposes

package android.view;

import android.animation.StateListAnimator;
import android.content.ClipData;
import android.content.Context;
import android.content.res.ColorStateList;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.graphics.Bitmap;
import android.graphics.BlendMode;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Point;
import android.graphics.PorterDuff;
import android.graphics.Rect;
import android.graphics.Region;
import android.graphics.RenderEffect;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Parcelable;
import android.util.AttributeSet;
import android.util.LongSparseArray;
import android.util.Property;
import android.util.SparseArray;
import android.view.ActionMode;
import android.view.AttachedSurfaceControl;
import android.view.ContentInfo;
import android.view.ContextMenu;
import android.view.Display;
import android.view.DragEvent;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.OnReceiveContentListener;
import android.view.PointerIcon;
import android.view.ScrollCaptureCallback;
import android.view.ScrollCaptureTarget;
import android.view.TouchDelegate;
import android.view.ViewGroup;
import android.view.ViewOutlineProvider;
import android.view.ViewOverlay;
import android.view.ViewParent;
import android.view.ViewPropertyAnimator;
import android.view.ViewStructure;
import android.view.ViewTreeObserver;
import android.view.WindowId;
import android.view.WindowInsets;
import android.view.WindowInsetsAnimation;
import android.view.WindowInsetsController;
import android.view.accessibility.AccessibilityEvent;
import android.view.accessibility.AccessibilityEventSource;
import android.view.accessibility.AccessibilityNodeInfo;
import android.view.accessibility.AccessibilityNodeProvider;
import android.view.animation.Animation;
import android.view.autofill.AutofillId;
import android.view.autofill.AutofillValue;
import android.view.contentcapture.ContentCaptureSession;
import android.view.displayhash.DisplayHashResultCallback;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputConnection;
import android.view.translation.TranslationCapability;
import android.view.translation.ViewTranslationCallback;
import android.view.translation.ViewTranslationRequest;
import android.view.translation.ViewTranslationResponse;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Executor;
import java.util.function.Consumer;

public class View implements AccessibilityEventSource, Drawable.Callback, KeyEvent.Callback
{
    protected View() {}
    protected ContextMenu.ContextMenuInfo getContextMenuInfo(){ return null; }
    protected Parcelable onSaveInstanceState(){ return null; }
    protected boolean awakenScrollBars(){ return false; }
    protected boolean awakenScrollBars(int p0){ return false; }
    protected boolean awakenScrollBars(int p0, boolean p1){ return false; }
    protected boolean dispatchGenericFocusedEvent(MotionEvent p0){ return false; }
    protected boolean dispatchGenericPointerEvent(MotionEvent p0){ return false; }
    protected boolean dispatchHoverEvent(MotionEvent p0){ return false; }
    protected boolean fitSystemWindows(Rect p0){ return false; }
    protected boolean isPaddingOffsetRequired(){ return false; }
    protected boolean onSetAlpha(int p0){ return false; }
    protected boolean overScrollBy(int p0, int p1, int p2, int p3, int p4, int p5, int p6, int p7, boolean p8){ return false; }
    protected boolean verifyDrawable(Drawable p0){ return false; }
    protected final void onDrawScrollBars(Canvas p0){}
    protected final void setMeasuredDimension(int p0, int p1){}
    protected float getBottomFadingEdgeStrength(){ return 0; }
    protected float getLeftFadingEdgeStrength(){ return 0; }
    protected float getRightFadingEdgeStrength(){ return 0; }
    protected float getTopFadingEdgeStrength(){ return 0; }
    protected int computeHorizontalScrollExtent(){ return 0; }
    protected int computeHorizontalScrollOffset(){ return 0; }
    protected int computeHorizontalScrollRange(){ return 0; }
    protected int computeVerticalScrollExtent(){ return 0; }
    protected int computeVerticalScrollOffset(){ return 0; }
    protected int computeVerticalScrollRange(){ return 0; }
    protected int getBottomPaddingOffset(){ return 0; }
    protected int getHorizontalScrollbarHeight(){ return 0; }
    protected int getLeftPaddingOffset(){ return 0; }
    protected int getRightPaddingOffset(){ return 0; }
    protected int getSuggestedMinimumHeight(){ return 0; }
    protected int getSuggestedMinimumWidth(){ return 0; }
    protected int getTopPaddingOffset(){ return 0; }
    protected int getWindowAttachCount(){ return 0; }
    protected int[] onCreateDrawableState(int p0){ return null; }
    protected static String VIEW_LOG_TAG = null;
    protected static int[] EMPTY_STATE_SET = null;
    protected static int[] ENABLED_FOCUSED_SELECTED_STATE_SET = null;
    protected static int[] ENABLED_FOCUSED_SELECTED_WINDOW_FOCUSED_STATE_SET = null;
    protected static int[] ENABLED_FOCUSED_STATE_SET = null;
    protected static int[] ENABLED_FOCUSED_WINDOW_FOCUSED_STATE_SET = null;
    protected static int[] ENABLED_SELECTED_STATE_SET = null;
    protected static int[] ENABLED_SELECTED_WINDOW_FOCUSED_STATE_SET = null;
    protected static int[] ENABLED_STATE_SET = null;
    protected static int[] ENABLED_WINDOW_FOCUSED_STATE_SET = null;
    protected static int[] FOCUSED_SELECTED_STATE_SET = null;
    protected static int[] FOCUSED_SELECTED_WINDOW_FOCUSED_STATE_SET = null;
    protected static int[] FOCUSED_STATE_SET = null;
    protected static int[] FOCUSED_WINDOW_FOCUSED_STATE_SET = null;
    protected static int[] PRESSED_ENABLED_FOCUSED_SELECTED_STATE_SET = null;
    protected static int[] PRESSED_ENABLED_FOCUSED_SELECTED_WINDOW_FOCUSED_STATE_SET = null;
    protected static int[] PRESSED_ENABLED_FOCUSED_STATE_SET = null;
    protected static int[] PRESSED_ENABLED_FOCUSED_WINDOW_FOCUSED_STATE_SET = null;
    protected static int[] PRESSED_ENABLED_SELECTED_STATE_SET = null;
    protected static int[] PRESSED_ENABLED_SELECTED_WINDOW_FOCUSED_STATE_SET = null;
    protected static int[] PRESSED_ENABLED_STATE_SET = null;
    protected static int[] PRESSED_ENABLED_WINDOW_FOCUSED_STATE_SET = null;
    protected static int[] PRESSED_FOCUSED_SELECTED_STATE_SET = null;
    protected static int[] PRESSED_FOCUSED_SELECTED_WINDOW_FOCUSED_STATE_SET = null;
    protected static int[] PRESSED_FOCUSED_STATE_SET = null;
    protected static int[] PRESSED_FOCUSED_WINDOW_FOCUSED_STATE_SET = null;
    protected static int[] PRESSED_SELECTED_STATE_SET = null;
    protected static int[] PRESSED_SELECTED_WINDOW_FOCUSED_STATE_SET = null;
    protected static int[] PRESSED_STATE_SET = null;
    protected static int[] PRESSED_WINDOW_FOCUSED_STATE_SET = null;
    protected static int[] SELECTED_STATE_SET = null;
    protected static int[] SELECTED_WINDOW_FOCUSED_STATE_SET = null;
    protected static int[] WINDOW_FOCUSED_STATE_SET = null;
    protected static int[] mergeDrawableStates(int[] p0, int[] p1){ return null; }
    protected void dispatchDraw(Canvas p0){}
    protected void dispatchRestoreInstanceState(SparseArray<Parcelable> p0){}
    protected void dispatchSaveInstanceState(SparseArray<Parcelable> p0){}
    protected void dispatchSetActivated(boolean p0){}
    protected void dispatchSetPressed(boolean p0){}
    protected void dispatchSetSelected(boolean p0){}
    protected void dispatchVisibilityChanged(View p0, int p1){}
    protected void drawableStateChanged(){}
    protected void onAnimationEnd(){}
    protected void onAnimationStart(){}
    protected void onAttachedToWindow(){}
    protected void onConfigurationChanged(Configuration p0){}
    protected void onCreateContextMenu(ContextMenu p0){}
    protected void onDetachedFromWindow(){}
    protected void onDisplayHint(int p0){}
    protected void onDraw(Canvas p0){}
    protected void onFinishInflate(){}
    protected void onFocusChanged(boolean p0, int p1, Rect p2){}
    protected void onLayout(boolean p0, int p1, int p2, int p3, int p4){}
    protected void onMeasure(int p0, int p1){}
    protected void onOverScrolled(int p0, int p1, boolean p2, boolean p3){}
    protected void onRestoreInstanceState(Parcelable p0){}
    protected void onScrollChanged(int p0, int p1, int p2, int p3){}
    protected void onSizeChanged(int p0, int p1, int p2, int p3){}
    protected void onVisibilityChanged(View p0, int p1){}
    protected void onWindowVisibilityChanged(int p0){}
    public AccessibilityNodeInfo createAccessibilityNodeInfo(){ return null; }
    public AccessibilityNodeProvider getAccessibilityNodeProvider(){ return null; }
    public ActionMode startActionMode(ActionMode.Callback p0){ return null; }
    public ActionMode startActionMode(ActionMode.Callback p0, int p1){ return null; }
    public Animation getAnimation(){ return null; }
    public ArrayList<View> getFocusables(int p0){ return null; }
    public ArrayList<View> getTouchables(){ return null; }
    public AttachedSurfaceControl getRootSurfaceControl(){ return null; }
    public AutofillValue getAutofillValue(){ return null; }
    public Bitmap getDrawingCache(){ return null; }
    public Bitmap getDrawingCache(boolean p0){ return null; }
    public BlendMode getBackgroundTintBlendMode(){ return null; }
    public BlendMode getForegroundTintBlendMode(){ return null; }
    public CharSequence getAccessibilityClassName(){ return null; }
    public CharSequence getAccessibilityPaneTitle(){ return null; }
    public CharSequence getContentDescription(){ return null; }
    public CharSequence getTooltipText(){ return null; }
    public ColorStateList getBackgroundTintList(){ return null; }
    public ColorStateList getForegroundTintList(){ return null; }
    public ContentInfo onReceiveContent(ContentInfo p0){ return null; }
    public ContentInfo performReceiveContent(ContentInfo p0){ return null; }
    public Display getDisplay(){ return null; }
    public Drawable getBackground(){ return null; }
    public Drawable getForeground(){ return null; }
    public Drawable getHorizontalScrollbarThumbDrawable(){ return null; }
    public Drawable getHorizontalScrollbarTrackDrawable(){ return null; }
    public Drawable getVerticalScrollbarThumbDrawable(){ return null; }
    public Drawable getVerticalScrollbarTrackDrawable(){ return null; }
    public Handler getHandler(){ return null; }
    public IBinder getApplicationWindowToken(){ return null; }
    public IBinder getWindowToken(){ return null; }
    public InputConnection onCreateInputConnection(EditorInfo p0){ return null; }
    public KeyEvent.DispatcherState getKeyDispatcherState(){ return null; }
    public List<Rect> getSystemGestureExclusionRects(){ return null; }
    public Map<Integer, Integer> getAttributeSourceResourceMap(){ return null; }
    public Matrix getAnimationMatrix(){ return null; }
    public Matrix getMatrix(){ return null; }
    public Object getTag(){ return null; }
    public Object getTag(int p0){ return null; }
    public PointerIcon getPointerIcon(){ return null; }
    public PointerIcon onResolvePointerIcon(MotionEvent p0, int p1){ return null; }
    public PorterDuff.Mode getBackgroundTintMode(){ return null; }
    public PorterDuff.Mode getForegroundTintMode(){ return null; }
    public Rect getClipBounds(){ return null; }
    public Resources getResources(){ return null; }
    public StateListAnimator getStateListAnimator(){ return null; }
    public String getTransitionName(){ return null; }
    public String toString(){ return null; }
    public String[] getAutofillHints(){ return null; }
    public String[] getReceiveContentMimeTypes(){ return null; }
    public TouchDelegate getTouchDelegate(){ return null; }
    public View findFocus(){ return null; }
    public View focusSearch(int p0){ return null; }
    public View getRootView(){ return null; }
    public View keyboardNavigationClusterSearch(View p0, int p1){ return null; }
    public View(Context p0){}
    public View(Context p0, AttributeSet p1){}
    public View(Context p0, AttributeSet p1, int p2){}
    public View(Context p0, AttributeSet p1, int p2, int p3){}
    public View.AccessibilityDelegate getAccessibilityDelegate(){ return null; }
    public View.OnFocusChangeListener getOnFocusChangeListener(){ return null; }
    public ViewGroup.LayoutParams getLayoutParams(){ return null; }
    public ViewOutlineProvider getOutlineProvider(){ return null; }
    public ViewOverlay getOverlay(){ return null; }
    public ViewParent getParentForAccessibility(){ return null; }
    public ViewPropertyAnimator animate(){ return null; }
    public ViewTranslationResponse getViewTranslationResponse(){ return null; }
    public ViewTreeObserver getViewTreeObserver(){ return null; }
    public WindowId getWindowId(){ return null; }
    public WindowInsets computeSystemWindowInsets(WindowInsets p0, Rect p1){ return null; }
    public WindowInsets dispatchApplyWindowInsets(WindowInsets p0){ return null; }
    public WindowInsets dispatchWindowInsetsAnimationProgress(WindowInsets p0, List<WindowInsetsAnimation> p1){ return null; }
    public WindowInsets getRootWindowInsets(){ return null; }
    public WindowInsets onApplyWindowInsets(WindowInsets p0){ return null; }
    public WindowInsetsAnimation.Bounds dispatchWindowInsetsAnimationStart(WindowInsetsAnimation p0, WindowInsetsAnimation.Bounds p1){ return null; }
    public WindowInsetsController getWindowInsetsController(){ return null; }
    public boolean callOnClick(){ return false; }
    public boolean canResolveLayoutDirection(){ return false; }
    public boolean canResolveTextAlignment(){ return false; }
    public boolean canResolveTextDirection(){ return false; }
    public boolean canScrollHorizontally(int p0){ return false; }
    public boolean canScrollVertically(int p0){ return false; }
    public boolean checkInputConnectionProxy(View p0){ return false; }
    public boolean dispatchCapturedPointerEvent(MotionEvent p0){ return false; }
    public boolean dispatchDragEvent(DragEvent p0){ return false; }
    public boolean dispatchGenericMotionEvent(MotionEvent p0){ return false; }
    public boolean dispatchKeyEvent(KeyEvent p0){ return false; }
    public boolean dispatchKeyEventPreIme(KeyEvent p0){ return false; }
    public boolean dispatchKeyShortcutEvent(KeyEvent p0){ return false; }
    public boolean dispatchNestedFling(float p0, float p1, boolean p2){ return false; }
    public boolean dispatchNestedPreFling(float p0, float p1){ return false; }
    public boolean dispatchNestedPrePerformAccessibilityAction(int p0, Bundle p1){ return false; }
    public boolean dispatchNestedPreScroll(int p0, int p1, int[] p2, int[] p3){ return false; }
    public boolean dispatchNestedScroll(int p0, int p1, int p2, int p3, int[] p4){ return false; }
    public boolean dispatchPopulateAccessibilityEvent(AccessibilityEvent p0){ return false; }
    public boolean dispatchTouchEvent(MotionEvent p0){ return false; }
    public boolean dispatchTrackballEvent(MotionEvent p0){ return false; }
    public boolean dispatchUnhandledMove(View p0, int p1){ return false; }
    public boolean gatherTransparentRegion(Region p0){ return false; }
    public boolean getClipBounds(Rect p0){ return false; }
    public boolean getFilterTouchesWhenObscured(){ return false; }
    public boolean getFitsSystemWindows(){ return false; }
    public boolean getGlobalVisibleRect(Rect p0, Point p1){ return false; }
    public boolean getKeepScreenOn(){ return false; }
    public boolean hasExplicitFocusable(){ return false; }
    public boolean hasFocus(){ return false; }
    public boolean hasFocusable(){ return false; }
    public boolean hasNestedScrollingParent(){ return false; }
    public boolean hasOnClickListeners(){ return false; }
    public boolean hasOnLongClickListeners(){ return false; }
    public boolean hasOverlappingRendering(){ return false; }
    public boolean hasPointerCapture(){ return false; }
    public boolean hasTransientState(){ return false; }
    public boolean hasWindowFocus(){ return false; }
    public boolean isAccessibilityFocused(){ return false; }
    public boolean isAccessibilityHeading(){ return false; }
    public boolean isActivated(){ return false; }
    public boolean isAttachedToWindow(){ return false; }
    public boolean isClickable(){ return false; }
    public boolean isContextClickable(){ return false; }
    public boolean isDirty(){ return false; }
    public boolean isDrawingCacheEnabled(){ return false; }
    public boolean isDuplicateParentStateEnabled(){ return false; }
    public boolean isEnabled(){ return false; }
    public boolean isFocused(){ return false; }
    public boolean isForceDarkAllowed(){ return false; }
    public boolean isHapticFeedbackEnabled(){ return false; }
    public boolean isHardwareAccelerated(){ return false; }
    public boolean isHorizontalFadingEdgeEnabled(){ return false; }
    public boolean isHorizontalScrollBarEnabled(){ return false; }
    public boolean isHovered(){ return false; }
    public boolean isImportantForAccessibility(){ return false; }
    public boolean isInEditMode(){ return false; }
    public boolean isInLayout(){ return false; }
    public boolean isInTouchMode(){ return false; }
    public boolean isLaidOut(){ return false; }
    public boolean isLayoutDirectionResolved(){ return false; }
    public boolean isLayoutRequested(){ return false; }
    public boolean isLongClickable(){ return false; }
    public boolean isNestedScrollingEnabled(){ return false; }
    public boolean isOpaque(){ return false; }
    public boolean isPaddingRelative(){ return false; }
    public boolean isPivotSet(){ return false; }
    public boolean isPressed(){ return false; }
    public boolean isSaveEnabled(){ return false; }
    public boolean isSaveFromParentEnabled(){ return false; }
    public boolean isScreenReaderFocusable(){ return false; }
    public boolean isScrollContainer(){ return false; }
    public boolean isScrollbarFadingEnabled(){ return false; }
    public boolean isSelected(){ return false; }
    public boolean isShown(){ return false; }
    public boolean isSoundEffectsEnabled(){ return false; }
    public boolean isTextAlignmentResolved(){ return false; }
    public boolean isTextDirectionResolved(){ return false; }
    public boolean isVerticalFadingEdgeEnabled(){ return false; }
    public boolean isVerticalScrollBarEnabled(){ return false; }
    public boolean isVisibleToUserForAutofill(int p0){ return false; }
    public boolean onCapturedPointerEvent(MotionEvent p0){ return false; }
    public boolean onCheckIsTextEditor(){ return false; }
    public boolean onDragEvent(DragEvent p0){ return false; }
    public boolean onFilterTouchEventForSecurity(MotionEvent p0){ return false; }
    public boolean onGenericMotionEvent(MotionEvent p0){ return false; }
    public boolean onHoverEvent(MotionEvent p0){ return false; }
    public boolean onKeyDown(int p0, KeyEvent p1){ return false; }
    public boolean onKeyLongPress(int p0, KeyEvent p1){ return false; }
    public boolean onKeyMultiple(int p0, int p1, KeyEvent p2){ return false; }
    public boolean onKeyPreIme(int p0, KeyEvent p1){ return false; }
    public boolean onKeyShortcut(int p0, KeyEvent p1){ return false; }
    public boolean onKeyUp(int p0, KeyEvent p1){ return false; }
    public boolean onTouchEvent(MotionEvent p0){ return false; }
    public boolean onTrackballEvent(MotionEvent p0){ return false; }
    public boolean performAccessibilityAction(int p0, Bundle p1){ return false; }
    public boolean performClick(){ return false; }
    public boolean performContextClick(){ return false; }
    public boolean performContextClick(float p0, float p1){ return false; }
    public boolean performHapticFeedback(int p0){ return false; }
    public boolean performHapticFeedback(int p0, int p1){ return false; }
    public boolean performLongClick(){ return false; }
    public boolean performLongClick(float p0, float p1){ return false; }
    public boolean post(Runnable p0){ return false; }
    public boolean postDelayed(Runnable p0, long p1){ return false; }
    public boolean removeCallbacks(Runnable p0){ return false; }
    public boolean requestFocus(int p0, Rect p1){ return false; }
    public boolean requestRectangleOnScreen(Rect p0){ return false; }
    public boolean requestRectangleOnScreen(Rect p0, boolean p1){ return false; }
    public boolean restoreDefaultFocus(){ return false; }
    public boolean showContextMenu(){ return false; }
    public boolean showContextMenu(float p0, float p1){ return false; }
    public boolean startNestedScroll(int p0){ return false; }
    public boolean willNotCacheDrawing(){ return false; }
    public boolean willNotDraw(){ return false; }
    public final <T extends View> T findViewById(int p0){ return null; }
    public final <T extends View> T findViewWithTag(Object p0){ return null; }
    public final <T extends View> T requireViewById(int p0){ return null; }
    public final AutofillId getAutofillId(){ return null; }
    public final CharSequence getStateDescription(){ return null; }
    public final ContentCaptureSession getContentCaptureSession(){ return null; }
    public final Context getContext(){ return null; }
    public final ViewParent getParent(){ return null; }
    public final boolean getClipToOutline(){ return false; }
    public final boolean getDefaultFocusHighlightEnabled(){ return false; }
    public final boolean getGlobalVisibleRect(Rect p0){ return false; }
    public final boolean getHasOverlappingRendering(){ return false; }
    public final boolean getLocalVisibleRect(Rect p0){ return false; }
    public final boolean getRevealOnFocusHint(){ return false; }
    public final boolean isFocusable(){ return false; }
    public final boolean isFocusableInTouchMode(){ return false; }
    public final boolean isFocusedByDefault(){ return false; }
    public final boolean isImportantForAutofill(){ return false; }
    public final boolean isImportantForContentCapture(){ return false; }
    public final boolean isKeyboardNavigationCluster(){ return false; }
    public final boolean isShowingLayoutBounds(){ return false; }
    public final boolean isTemporarilyDetached(){ return false; }
    public final boolean requestFocus(){ return false; }
    public final boolean requestFocus(int p0){ return false; }
    public final boolean requestFocusFromTouch(){ return false; }
    public final boolean startDrag(ClipData p0, View.DragShadowBuilder p1, Object p2, int p3){ return false; }
    public final boolean startDragAndDrop(ClipData p0, View.DragShadowBuilder p1, Object p2, int p3){ return false; }
    public final int getBottom(){ return 0; }
    public final int getHeight(){ return 0; }
    public final int getLeft(){ return 0; }
    public final int getMeasuredHeight(){ return 0; }
    public final int getMeasuredHeightAndState(){ return 0; }
    public final int getMeasuredState(){ return 0; }
    public final int getMeasuredWidth(){ return 0; }
    public final int getMeasuredWidthAndState(){ return 0; }
    public final int getRight(){ return 0; }
    public final int getScrollX(){ return 0; }
    public final int getScrollY(){ return 0; }
    public final int getTop(){ return 0; }
    public final int getWidth(){ return 0; }
    public final int[] getDrawableState(){ return null; }
    public final void cancelDragAndDrop(){}
    public final void cancelPendingInputEvents(){}
    public final void measure(int p0, int p1){}
    public final void requestUnbufferedDispatch(MotionEvent p0){}
    public final void requestUnbufferedDispatch(int p0){}
    public final void saveAttributeDataForStyleable(Context p0, int[] p1, AttributeSet p2, TypedArray p3, int p4, int p5){}
    public final void setBottom(int p0){}
    public final void setLeft(int p0){}
    public final void setLeftTopRightBottom(int p0, int p1, int p2, int p3){}
    public final void setRevealOnFocusHint(boolean p0){}
    public final void setRight(int p0){}
    public final void setScrollCaptureCallback(ScrollCaptureCallback p0){}
    public final void setTop(int p0){}
    public final void setTransitionName(String p0){}
    public final void updateDragShadow(View.DragShadowBuilder p0){}
    public float getAlpha(){ return 0; }
    public float getCameraDistance(){ return 0; }
    public float getElevation(){ return 0; }
    public float getPivotX(){ return 0; }
    public float getPivotY(){ return 0; }
    public float getRotation(){ return 0; }
    public float getRotationX(){ return 0; }
    public float getRotationY(){ return 0; }
    public float getScaleX(){ return 0; }
    public float getScaleY(){ return 0; }
    public float getTransitionAlpha(){ return 0; }
    public float getTranslationX(){ return 0; }
    public float getTranslationY(){ return 0; }
    public float getTranslationZ(){ return 0; }
    public float getX(){ return 0; }
    public float getY(){ return 0; }
    public float getZ(){ return 0; }
    public int getAccessibilityLiveRegion(){ return 0; }
    public int getAccessibilityTraversalAfter(){ return 0; }
    public int getAccessibilityTraversalBefore(){ return 0; }
    public int getAutofillType(){ return 0; }
    public int getBaseline(){ return 0; }
    public int getDrawingCacheBackgroundColor(){ return 0; }
    public int getDrawingCacheQuality(){ return 0; }
    public int getExplicitStyle(){ return 0; }
    public int getFocusable(){ return 0; }
    public int getForegroundGravity(){ return 0; }
    public int getHorizontalFadingEdgeLength(){ return 0; }
    public int getId(){ return 0; }
    public int getImportantForAccessibility(){ return 0; }
    public int getImportantForAutofill(){ return 0; }
    public int getImportantForContentCapture(){ return 0; }
    public int getLabelFor(){ return 0; }
    public int getLayerType(){ return 0; }
    public int getLayoutDirection(){ return 0; }
    public int getMinimumHeight(){ return 0; }
    public int getMinimumWidth(){ return 0; }
    public int getNextClusterForwardId(){ return 0; }
    public int getNextFocusDownId(){ return 0; }
    public int getNextFocusForwardId(){ return 0; }
    public int getNextFocusLeftId(){ return 0; }
    public int getNextFocusRightId(){ return 0; }
    public int getNextFocusUpId(){ return 0; }
    public int getOutlineAmbientShadowColor(){ return 0; }
    public int getOutlineSpotShadowColor(){ return 0; }
    public int getOverScrollMode(){ return 0; }
    public int getPaddingBottom(){ return 0; }
    public int getPaddingEnd(){ return 0; }
    public int getPaddingLeft(){ return 0; }
    public int getPaddingRight(){ return 0; }
    public int getPaddingStart(){ return 0; }
    public int getPaddingTop(){ return 0; }
    public int getScrollBarDefaultDelayBeforeFade(){ return 0; }
    public int getScrollBarFadeDuration(){ return 0; }
    public int getScrollBarSize(){ return 0; }
    public int getScrollBarStyle(){ return 0; }
    public int getScrollCaptureHint(){ return 0; }
    public int getScrollIndicators(){ return 0; }
    public int getSolidColor(){ return 0; }
    public int getSourceLayoutResId(){ return 0; }
    public int getSystemUiVisibility(){ return 0; }
    public int getTextAlignment(){ return 0; }
    public int getTextDirection(){ return 0; }
    public int getVerticalFadingEdgeLength(){ return 0; }
    public int getVerticalScrollbarPosition(){ return 0; }
    public int getVerticalScrollbarWidth(){ return 0; }
    public int getVisibility(){ return 0; }
    public int getWindowSystemUiVisibility(){ return 0; }
    public int getWindowVisibility(){ return 0; }
    public int[] getAttributeResolutionStack(int p0){ return null; }
    public long getDrawingTime(){ return 0; }
    public long getUniqueDrawingId(){ return 0; }
    public static Property<View, Float> ALPHA = null;
    public static Property<View, Float> ROTATION = null;
    public static Property<View, Float> ROTATION_X = null;
    public static Property<View, Float> ROTATION_Y = null;
    public static Property<View, Float> SCALE_X = null;
    public static Property<View, Float> SCALE_Y = null;
    public static Property<View, Float> TRANSLATION_X = null;
    public static Property<View, Float> TRANSLATION_Y = null;
    public static Property<View, Float> TRANSLATION_Z = null;
    public static Property<View, Float> X = null;
    public static Property<View, Float> Y = null;
    public static Property<View, Float> Z = null;
    public static String AUTOFILL_HINT_CREDIT_CARD_EXPIRATION_DATE = null;
    public static String AUTOFILL_HINT_CREDIT_CARD_EXPIRATION_DAY = null;
    public static String AUTOFILL_HINT_CREDIT_CARD_EXPIRATION_MONTH = null;
    public static String AUTOFILL_HINT_CREDIT_CARD_EXPIRATION_YEAR = null;
    public static String AUTOFILL_HINT_CREDIT_CARD_NUMBER = null;
    public static String AUTOFILL_HINT_CREDIT_CARD_SECURITY_CODE = null;
    public static String AUTOFILL_HINT_EMAIL_ADDRESS = null;
    public static String AUTOFILL_HINT_NAME = null;
    public static String AUTOFILL_HINT_PASSWORD = null;
    public static String AUTOFILL_HINT_PHONE = null;
    public static String AUTOFILL_HINT_POSTAL_ADDRESS = null;
    public static String AUTOFILL_HINT_POSTAL_CODE = null;
    public static String AUTOFILL_HINT_USERNAME = null;
    public static View inflate(Context p0, int p1, ViewGroup p2){ return null; }
    public static int ACCESSIBILITY_LIVE_REGION_ASSERTIVE = 0;
    public static int ACCESSIBILITY_LIVE_REGION_NONE = 0;
    public static int ACCESSIBILITY_LIVE_REGION_POLITE = 0;
    public static int AUTOFILL_FLAG_INCLUDE_NOT_IMPORTANT_VIEWS = 0;
    public static int AUTOFILL_TYPE_DATE = 0;
    public static int AUTOFILL_TYPE_LIST = 0;
    public static int AUTOFILL_TYPE_NONE = 0;
    public static int AUTOFILL_TYPE_TEXT = 0;
    public static int AUTOFILL_TYPE_TOGGLE = 0;
    public static int DRAG_FLAG_GLOBAL = 0;
    public static int DRAG_FLAG_GLOBAL_PERSISTABLE_URI_PERMISSION = 0;
    public static int DRAG_FLAG_GLOBAL_PREFIX_URI_PERMISSION = 0;
    public static int DRAG_FLAG_GLOBAL_URI_READ = 0;
    public static int DRAG_FLAG_GLOBAL_URI_WRITE = 0;
    public static int DRAG_FLAG_OPAQUE = 0;
    public static int DRAWING_CACHE_QUALITY_AUTO = 0;
    public static int DRAWING_CACHE_QUALITY_HIGH = 0;
    public static int DRAWING_CACHE_QUALITY_LOW = 0;
    public static int FIND_VIEWS_WITH_CONTENT_DESCRIPTION = 0;
    public static int FIND_VIEWS_WITH_TEXT = 0;
    public static int FOCUSABLE = 0;
    public static int FOCUSABLES_ALL = 0;
    public static int FOCUSABLES_TOUCH_MODE = 0;
    public static int FOCUSABLE_AUTO = 0;
    public static int FOCUS_BACKWARD = 0;
    public static int FOCUS_DOWN = 0;
    public static int FOCUS_FORWARD = 0;
    public static int FOCUS_LEFT = 0;
    public static int FOCUS_RIGHT = 0;
    public static int FOCUS_UP = 0;
    public static int GONE = 0;
    public static int HAPTIC_FEEDBACK_ENABLED = 0;
    public static int IMPORTANT_FOR_ACCESSIBILITY_AUTO = 0;
    public static int IMPORTANT_FOR_ACCESSIBILITY_NO = 0;
    public static int IMPORTANT_FOR_ACCESSIBILITY_NO_HIDE_DESCENDANTS = 0;
    public static int IMPORTANT_FOR_ACCESSIBILITY_YES = 0;
    public static int IMPORTANT_FOR_AUTOFILL_AUTO = 0;
    public static int IMPORTANT_FOR_AUTOFILL_NO = 0;
    public static int IMPORTANT_FOR_AUTOFILL_NO_EXCLUDE_DESCENDANTS = 0;
    public static int IMPORTANT_FOR_AUTOFILL_YES = 0;
    public static int IMPORTANT_FOR_AUTOFILL_YES_EXCLUDE_DESCENDANTS = 0;
    public static int IMPORTANT_FOR_CONTENT_CAPTURE_AUTO = 0;
    public static int IMPORTANT_FOR_CONTENT_CAPTURE_NO = 0;
    public static int IMPORTANT_FOR_CONTENT_CAPTURE_NO_EXCLUDE_DESCENDANTS = 0;
    public static int IMPORTANT_FOR_CONTENT_CAPTURE_YES = 0;
    public static int IMPORTANT_FOR_CONTENT_CAPTURE_YES_EXCLUDE_DESCENDANTS = 0;
    public static int INVISIBLE = 0;
    public static int KEEP_SCREEN_ON = 0;
    public static int LAYER_TYPE_HARDWARE = 0;
    public static int LAYER_TYPE_NONE = 0;
    public static int LAYER_TYPE_SOFTWARE = 0;
    public static int LAYOUT_DIRECTION_INHERIT = 0;
    public static int LAYOUT_DIRECTION_LOCALE = 0;
    public static int LAYOUT_DIRECTION_LTR = 0;
    public static int LAYOUT_DIRECTION_RTL = 0;
    public static int MEASURED_HEIGHT_STATE_SHIFT = 0;
    public static int MEASURED_SIZE_MASK = 0;
    public static int MEASURED_STATE_MASK = 0;
    public static int MEASURED_STATE_TOO_SMALL = 0;
    public static int NOT_FOCUSABLE = 0;
    public static int NO_ID = 0;
    public static int OVER_SCROLL_ALWAYS = 0;
    public static int OVER_SCROLL_IF_CONTENT_SCROLLS = 0;
    public static int OVER_SCROLL_NEVER = 0;
    public static int SCREEN_STATE_OFF = 0;
    public static int SCREEN_STATE_ON = 0;
    public static int SCROLLBARS_INSIDE_INSET = 0;
    public static int SCROLLBARS_INSIDE_OVERLAY = 0;
    public static int SCROLLBARS_OUTSIDE_INSET = 0;
    public static int SCROLLBARS_OUTSIDE_OVERLAY = 0;
    public static int SCROLLBAR_POSITION_DEFAULT = 0;
    public static int SCROLLBAR_POSITION_LEFT = 0;
    public static int SCROLLBAR_POSITION_RIGHT = 0;
    public static int SCROLL_AXIS_HORIZONTAL = 0;
    public static int SCROLL_AXIS_NONE = 0;
    public static int SCROLL_AXIS_VERTICAL = 0;
    public static int SCROLL_CAPTURE_HINT_AUTO = 0;
    public static int SCROLL_CAPTURE_HINT_EXCLUDE = 0;
    public static int SCROLL_CAPTURE_HINT_EXCLUDE_DESCENDANTS = 0;
    public static int SCROLL_CAPTURE_HINT_INCLUDE = 0;
    public static int SCROLL_INDICATOR_BOTTOM = 0;
    public static int SCROLL_INDICATOR_END = 0;
    public static int SCROLL_INDICATOR_LEFT = 0;
    public static int SCROLL_INDICATOR_RIGHT = 0;
    public static int SCROLL_INDICATOR_START = 0;
    public static int SCROLL_INDICATOR_TOP = 0;
    public static int SOUND_EFFECTS_ENABLED = 0;
    public static int STATUS_BAR_HIDDEN = 0;
    public static int STATUS_BAR_VISIBLE = 0;
    public static int SYSTEM_UI_FLAG_FULLSCREEN = 0;
    public static int SYSTEM_UI_FLAG_HIDE_NAVIGATION = 0;
    public static int SYSTEM_UI_FLAG_IMMERSIVE = 0;
    public static int SYSTEM_UI_FLAG_IMMERSIVE_STICKY = 0;
    public static int SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN = 0;
    public static int SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION = 0;
    public static int SYSTEM_UI_FLAG_LAYOUT_STABLE = 0;
    public static int SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR = 0;
    public static int SYSTEM_UI_FLAG_LIGHT_STATUS_BAR = 0;
    public static int SYSTEM_UI_FLAG_LOW_PROFILE = 0;
    public static int SYSTEM_UI_FLAG_VISIBLE = 0;
    public static int SYSTEM_UI_LAYOUT_FLAGS = 0;
    public static int TEXT_ALIGNMENT_CENTER = 0;
    public static int TEXT_ALIGNMENT_GRAVITY = 0;
    public static int TEXT_ALIGNMENT_INHERIT = 0;
    public static int TEXT_ALIGNMENT_TEXT_END = 0;
    public static int TEXT_ALIGNMENT_TEXT_START = 0;
    public static int TEXT_ALIGNMENT_VIEW_END = 0;
    public static int TEXT_ALIGNMENT_VIEW_START = 0;
    public static int TEXT_DIRECTION_ANY_RTL = 0;
    public static int TEXT_DIRECTION_FIRST_STRONG = 0;
    public static int TEXT_DIRECTION_FIRST_STRONG_LTR = 0;
    public static int TEXT_DIRECTION_FIRST_STRONG_RTL = 0;
    public static int TEXT_DIRECTION_INHERIT = 0;
    public static int TEXT_DIRECTION_LOCALE = 0;
    public static int TEXT_DIRECTION_LTR = 0;
    public static int TEXT_DIRECTION_RTL = 0;
    public static int VISIBLE = 0;
    public static int combineMeasuredStates(int p0, int p1){ return 0; }
    public static int generateViewId(){ return 0; }
    public static int getDefaultSize(int p0, int p1){ return 0; }
    public static int resolveSize(int p0, int p1){ return 0; }
    public static int resolveSizeAndState(int p0, int p1, int p2){ return 0; }
    public void addChildrenForAccessibility(ArrayList<View> p0){}
    public void addExtraDataToAccessibilityNodeInfo(AccessibilityNodeInfo p0, String p1, Bundle p2){}
    public void addFocusables(ArrayList<View> p0, int p1){}
    public void addFocusables(ArrayList<View> p0, int p1, int p2){}
    public void addKeyboardNavigationClusters(Collection<View> p0, int p1){}
    public void addOnAttachStateChangeListener(View.OnAttachStateChangeListener p0){}
    public void addOnLayoutChangeListener(View.OnLayoutChangeListener p0){}
    public void addOnUnhandledKeyEventListener(View.OnUnhandledKeyEventListener p0){}
    public void addTouchables(ArrayList<View> p0){}
    public void announceForAccessibility(CharSequence p0){}
    public void autofill(AutofillValue p0){}
    public void autofill(SparseArray<AutofillValue> p0){}
    public void bringToFront(){}
    public void buildDrawingCache(){}
    public void buildDrawingCache(boolean p0){}
    public void buildLayer(){}
    public void cancelLongPress(){}
    public void clearAnimation(){}
    public void clearFocus(){}
    public void clearViewTranslationCallback(){}
    public void computeScroll(){}
    public void createContextMenu(ContextMenu p0){}
    public void destroyDrawingCache(){}
    public void dispatchConfigurationChanged(Configuration p0){}
    public void dispatchCreateViewTranslationRequest(Map<AutofillId, long[]> p0, int[] p1, TranslationCapability p2, List<ViewTranslationRequest> p3){}
    public void dispatchDisplayHint(int p0){}
    public void dispatchDrawableHotspotChanged(float p0, float p1){}
    public void dispatchFinishTemporaryDetach(){}
    public void dispatchPointerCaptureChanged(boolean p0){}
    public void dispatchProvideAutofillStructure(ViewStructure p0, int p1){}
    public void dispatchProvideStructure(ViewStructure p0){}
    public void dispatchScrollCaptureSearch(Rect p0, Point p1, Consumer<ScrollCaptureTarget> p2){}
    public void dispatchStartTemporaryDetach(){}
    public void dispatchSystemUiVisibilityChanged(int p0){}
    public void dispatchWindowFocusChanged(boolean p0){}
    public void dispatchWindowInsetsAnimationEnd(WindowInsetsAnimation p0){}
    public void dispatchWindowInsetsAnimationPrepare(WindowInsetsAnimation p0){}
    public void dispatchWindowSystemUiVisiblityChanged(int p0){}
    public void dispatchWindowVisibilityChanged(int p0){}
    public void draw(Canvas p0){}
    public void drawableHotspotChanged(float p0, float p1){}
    public void findViewsWithText(ArrayList<View> p0, CharSequence p1, int p2){}
    public void forceHasOverlappingRendering(boolean p0){}
    public void forceLayout(){}
    public void generateDisplayHash(String p0, Rect p1, Executor p2, DisplayHashResultCallback p3){}
    public void getDrawingRect(Rect p0){}
    public void getFocusedRect(Rect p0){}
    public void getHitRect(Rect p0){}
    public void getLocationInSurface(int[] p0){}
    public void getLocationInWindow(int[] p0){}
    public void getLocationOnScreen(int[] p0){}
    public void getWindowVisibleDisplayFrame(Rect p0){}
    public void invalidate(){}
    public void invalidate(Rect p0){}
    public void invalidate(int p0, int p1, int p2, int p3){}
    public void invalidateDrawable(Drawable p0){}
    public void invalidateOutline(){}
    public void jumpDrawablesToCurrentState(){}
    public void layout(int p0, int p1, int p2, int p3){}
    public void offsetLeftAndRight(int p0){}
    public void offsetTopAndBottom(int p0){}
    public void onCancelPendingInputEvents(){}
    public void onCreateViewTranslationRequest(int[] p0, Consumer<ViewTranslationRequest> p1){}
    public void onCreateVirtualViewTranslationRequests(long[] p0, int[] p1, Consumer<ViewTranslationRequest> p2){}
    public void onDrawForeground(Canvas p0){}
    public void onFinishTemporaryDetach(){}
    public void onHoverChanged(boolean p0){}
    public void onInitializeAccessibilityEvent(AccessibilityEvent p0){}
    public void onInitializeAccessibilityNodeInfo(AccessibilityNodeInfo p0){}
    public void onPointerCaptureChange(boolean p0){}
    public void onPopulateAccessibilityEvent(AccessibilityEvent p0){}
    public void onProvideAutofillStructure(ViewStructure p0, int p1){}
    public void onProvideAutofillVirtualStructure(ViewStructure p0, int p1){}
    public void onProvideContentCaptureStructure(ViewStructure p0, int p1){}
    public void onProvideStructure(ViewStructure p0){}
    public void onProvideVirtualStructure(ViewStructure p0){}
    public void onRtlPropertiesChanged(int p0){}
    public void onScreenStateChanged(int p0){}
    public void onScrollCaptureSearch(Rect p0, Point p1, Consumer<ScrollCaptureTarget> p2){}
    public void onStartTemporaryDetach(){}
    public void onViewTranslationResponse(ViewTranslationResponse p0){}
    public void onVirtualViewTranslationResponses(LongSparseArray<ViewTranslationResponse> p0){}
    public void onVisibilityAggregated(boolean p0){}
    public void onWindowFocusChanged(boolean p0){}
    public void onWindowSystemUiVisibilityChanged(int p0){}
    public void playSoundEffect(int p0){}
    public void postInvalidate(){}
    public void postInvalidate(int p0, int p1, int p2, int p3){}
    public void postInvalidateDelayed(long p0){}
    public void postInvalidateDelayed(long p0, int p1, int p2, int p3, int p4){}
    public void postInvalidateOnAnimation(){}
    public void postInvalidateOnAnimation(int p0, int p1, int p2, int p3){}
    public void postOnAnimation(Runnable p0){}
    public void postOnAnimationDelayed(Runnable p0, long p1){}
    public void refreshDrawableState(){}
    public void releasePointerCapture(){}
    public void removeOnAttachStateChangeListener(View.OnAttachStateChangeListener p0){}
    public void removeOnLayoutChangeListener(View.OnLayoutChangeListener p0){}
    public void removeOnUnhandledKeyEventListener(View.OnUnhandledKeyEventListener p0){}
    public void requestApplyInsets(){}
    public void requestFitSystemWindows(){}
    public void requestLayout(){}
    public void requestPointerCapture(){}
    public void resetPivot(){}
    public void restoreHierarchyState(SparseArray<Parcelable> p0){}
    public void saveHierarchyState(SparseArray<Parcelable> p0){}
    public void scheduleDrawable(Drawable p0, Runnable p1, long p2){}
    public void scrollBy(int p0, int p1){}
    public void scrollTo(int p0, int p1){}
    public void sendAccessibilityEvent(int p0){}
    public void sendAccessibilityEventUnchecked(AccessibilityEvent p0){}
    public void setAccessibilityDelegate(View.AccessibilityDelegate p0){}
    public void setAccessibilityHeading(boolean p0){}
    public void setAccessibilityLiveRegion(int p0){}
    public void setAccessibilityPaneTitle(CharSequence p0){}
    public void setAccessibilityTraversalAfter(int p0){}
    public void setAccessibilityTraversalBefore(int p0){}
    public void setActivated(boolean p0){}
    public void setAllowClickWhenDisabled(boolean p0){}
    public void setAlpha(float p0){}
    public void setAnimation(Animation p0){}
    public void setAnimationMatrix(Matrix p0){}
    public void setAutofillHints(String... p0){}
    public void setAutofillId(AutofillId p0){}
    public void setBackground(Drawable p0){}
    public void setBackgroundColor(int p0){}
    public void setBackgroundDrawable(Drawable p0){}
    public void setBackgroundResource(int p0){}
    public void setBackgroundTintBlendMode(BlendMode p0){}
    public void setBackgroundTintList(ColorStateList p0){}
    public void setBackgroundTintMode(PorterDuff.Mode p0){}
    public void setCameraDistance(float p0){}
    public void setClickable(boolean p0){}
    public void setClipBounds(Rect p0){}
    public void setClipToOutline(boolean p0){}
    public void setContentCaptureSession(ContentCaptureSession p0){}
    public void setContentDescription(CharSequence p0){}
    public void setContextClickable(boolean p0){}
    public void setDefaultFocusHighlightEnabled(boolean p0){}
    public void setDrawingCacheBackgroundColor(int p0){}
    public void setDrawingCacheEnabled(boolean p0){}
    public void setDrawingCacheQuality(int p0){}
    public void setDuplicateParentStateEnabled(boolean p0){}
    public void setElevation(float p0){}
    public void setEnabled(boolean p0){}
    public void setFadingEdgeLength(int p0){}
    public void setFilterTouchesWhenObscured(boolean p0){}
    public void setFitsSystemWindows(boolean p0){}
    public void setFocusable(boolean p0){}
    public void setFocusable(int p0){}
    public void setFocusableInTouchMode(boolean p0){}
    public void setFocusedByDefault(boolean p0){}
    public void setForceDarkAllowed(boolean p0){}
    public void setForeground(Drawable p0){}
    public void setForegroundGravity(int p0){}
    public void setForegroundTintBlendMode(BlendMode p0){}
    public void setForegroundTintList(ColorStateList p0){}
    public void setForegroundTintMode(PorterDuff.Mode p0){}
    public void setHapticFeedbackEnabled(boolean p0){}
    public void setHasTransientState(boolean p0){}
    public void setHorizontalFadingEdgeEnabled(boolean p0){}
    public void setHorizontalScrollBarEnabled(boolean p0){}
    public void setHorizontalScrollbarThumbDrawable(Drawable p0){}
    public void setHorizontalScrollbarTrackDrawable(Drawable p0){}
    public void setHovered(boolean p0){}
    public void setId(int p0){}
    public void setImportantForAccessibility(int p0){}
    public void setImportantForAutofill(int p0){}
    public void setImportantForContentCapture(int p0){}
    public void setKeepScreenOn(boolean p0){}
    public void setKeyboardNavigationCluster(boolean p0){}
    public void setLabelFor(int p0){}
    public void setLayerPaint(Paint p0){}
    public void setLayerType(int p0, Paint p1){}
    public void setLayoutDirection(int p0){}
    public void setLayoutParams(ViewGroup.LayoutParams p0){}
    public void setLongClickable(boolean p0){}
    public void setMinimumHeight(int p0){}
    public void setMinimumWidth(int p0){}
    public void setNestedScrollingEnabled(boolean p0){}
    public void setNextClusterForwardId(int p0){}
    public void setNextFocusDownId(int p0){}
    public void setNextFocusForwardId(int p0){}
    public void setNextFocusLeftId(int p0){}
    public void setNextFocusRightId(int p0){}
    public void setNextFocusUpId(int p0){}
    public void setOnApplyWindowInsetsListener(View.OnApplyWindowInsetsListener p0){}
    public void setOnCapturedPointerListener(View.OnCapturedPointerListener p0){}
    public void setOnClickListener(View.OnClickListener p0){}
    public void setOnContextClickListener(View.OnContextClickListener p0){}
    public void setOnCreateContextMenuListener(View.OnCreateContextMenuListener p0){}
    public void setOnDragListener(View.OnDragListener p0){}
    public void setOnFocusChangeListener(View.OnFocusChangeListener p0){}
    public void setOnGenericMotionListener(View.OnGenericMotionListener p0){}
    public void setOnHoverListener(View.OnHoverListener p0){}
    public void setOnKeyListener(View.OnKeyListener p0){}
    public void setOnLongClickListener(View.OnLongClickListener p0){}
    public void setOnReceiveContentListener(String[] p0, OnReceiveContentListener p1){}
    public void setOnScrollChangeListener(View.OnScrollChangeListener p0){}
    public void setOnSystemUiVisibilityChangeListener(View.OnSystemUiVisibilityChangeListener p0){}
    public void setOnTouchListener(View.OnTouchListener p0){}
    public void setOutlineAmbientShadowColor(int p0){}
    public void setOutlineProvider(ViewOutlineProvider p0){}
    public void setOutlineSpotShadowColor(int p0){}
    public void setOverScrollMode(int p0){}
    public void setPadding(int p0, int p1, int p2, int p3){}
    public void setPaddingRelative(int p0, int p1, int p2, int p3){}
    public void setPivotX(float p0){}
    public void setPivotY(float p0){}
    public void setPointerIcon(PointerIcon p0){}
    public void setPressed(boolean p0){}
    public void setRenderEffect(RenderEffect p0){}
    public void setRotation(float p0){}
    public void setRotationX(float p0){}
    public void setRotationY(float p0){}
    public void setSaveEnabled(boolean p0){}
    public void setSaveFromParentEnabled(boolean p0){}
    public void setScaleX(float p0){}
    public void setScaleY(float p0){}
    public void setScreenReaderFocusable(boolean p0){}
    public void setScrollBarDefaultDelayBeforeFade(int p0){}
    public void setScrollBarFadeDuration(int p0){}
    public void setScrollBarSize(int p0){}
    public void setScrollBarStyle(int p0){}
    public void setScrollCaptureHint(int p0){}
    public void setScrollContainer(boolean p0){}
    public void setScrollIndicators(int p0){}
    public void setScrollIndicators(int p0, int p1){}
    public void setScrollX(int p0){}
    public void setScrollY(int p0){}
    public void setScrollbarFadingEnabled(boolean p0){}
    public void setSelected(boolean p0){}
    public void setSoundEffectsEnabled(boolean p0){}
    public void setStateDescription(CharSequence p0){}
    public void setStateListAnimator(StateListAnimator p0){}
    public void setSystemGestureExclusionRects(List<Rect> p0){}
    public void setSystemUiVisibility(int p0){}
    public void setTag(Object p0){}
    public void setTag(int p0, Object p1){}
    public void setTextAlignment(int p0){}
    public void setTextDirection(int p0){}
    public void setTooltipText(CharSequence p0){}
    public void setTouchDelegate(TouchDelegate p0){}
    public void setTransitionAlpha(float p0){}
    public void setTransitionVisibility(int p0){}
    public void setTranslationX(float p0){}
    public void setTranslationY(float p0){}
    public void setTranslationZ(float p0){}
    public void setVerticalFadingEdgeEnabled(boolean p0){}
    public void setVerticalScrollBarEnabled(boolean p0){}
    public void setVerticalScrollbarPosition(int p0){}
    public void setVerticalScrollbarThumbDrawable(Drawable p0){}
    public void setVerticalScrollbarTrackDrawable(Drawable p0){}
    public void setViewTranslationCallback(ViewTranslationCallback p0){}
    public void setVisibility(int p0){}
    public void setWillNotCacheDrawing(boolean p0){}
    public void setWillNotDraw(boolean p0){}
    public void setWindowInsetsAnimationCallback(WindowInsetsAnimation.Callback p0){}
    public void setX(float p0){}
    public void setY(float p0){}
    public void setZ(float p0){}
    public void startAnimation(Animation p0){}
    public void stopNestedScroll(){}
    public void transformMatrixToGlobal(Matrix p0){}
    public void transformMatrixToLocal(Matrix p0){}
    public void unscheduleDrawable(Drawable p0){}
    public void unscheduleDrawable(Drawable p0, Runnable p1){}
    static public class AccessibilityDelegate
    {
        public AccessibilityDelegate(){}
        public AccessibilityNodeProvider getAccessibilityNodeProvider(View p0){ return null; }
        public boolean dispatchPopulateAccessibilityEvent(View p0, AccessibilityEvent p1){ return false; }
        public boolean onRequestSendAccessibilityEvent(ViewGroup p0, View p1, AccessibilityEvent p2){ return false; }
        public boolean performAccessibilityAction(View p0, int p1, Bundle p2){ return false; }
        public void addExtraDataToAccessibilityNodeInfo(View p0, AccessibilityNodeInfo p1, String p2, Bundle p3){}
        public void onInitializeAccessibilityEvent(View p0, AccessibilityEvent p1){}
        public void onInitializeAccessibilityNodeInfo(View p0, AccessibilityNodeInfo p1){}
        public void onPopulateAccessibilityEvent(View p0, AccessibilityEvent p1){}
        public void sendAccessibilityEvent(View p0, int p1){}
        public void sendAccessibilityEventUnchecked(View p0, AccessibilityEvent p1){}
    }
    static public class DragShadowBuilder
    {
        public DragShadowBuilder(){}
        public DragShadowBuilder(View p0){}
        public final View getView(){ return null; }
        public void onDrawShadow(Canvas p0){}
        public void onProvideShadowMetrics(Point p0, Point p1){}
    }
    static public interface OnApplyWindowInsetsListener
    {
        WindowInsets onApplyWindowInsets(View p0, WindowInsets p1);
    }
    static public interface OnAttachStateChangeListener
    {
        void onViewAttachedToWindow(View p0);
        void onViewDetachedFromWindow(View p0);
    }
    static public interface OnCapturedPointerListener
    {
        boolean onCapturedPointer(View p0, MotionEvent p1);
    }
    static public interface OnClickListener
    {
        void onClick(View p0);
    }
    static public interface OnContextClickListener
    {
        boolean onContextClick(View p0);
    }
    static public interface OnCreateContextMenuListener
    {
        void onCreateContextMenu(ContextMenu p0, View p1, ContextMenu.ContextMenuInfo p2);
    }
    static public interface OnDragListener
    {
        boolean onDrag(View p0, DragEvent p1);
    }
    static public interface OnFocusChangeListener
    {
        void onFocusChange(View p0, boolean p1);
    }
    static public interface OnGenericMotionListener
    {
        boolean onGenericMotion(View p0, MotionEvent p1);
    }
    static public interface OnHoverListener
    {
        boolean onHover(View p0, MotionEvent p1);
    }
    static public interface OnKeyListener
    {
        boolean onKey(View p0, int p1, KeyEvent p2);
    }
    static public interface OnLayoutChangeListener
    {
        void onLayoutChange(View p0, int p1, int p2, int p3, int p4, int p5, int p6, int p7, int p8);
    }
    static public interface OnLongClickListener
    {
        boolean onLongClick(View p0);
    }
    static public interface OnScrollChangeListener
    {
        void onScrollChange(View p0, int p1, int p2, int p3, int p4);
    }
    static public interface OnSystemUiVisibilityChangeListener
    {
        void onSystemUiVisibilityChange(int p0);
    }
    static public interface OnTouchListener
    {
        boolean onTouch(View p0, MotionEvent p1);
    }
    static public interface OnUnhandledKeyEventListener
    {
        boolean onUnhandledKeyEvent(View p0, KeyEvent p1);
    }
}
