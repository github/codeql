/*
 * Copyright (C) 2006 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */

package android.view;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.function.Predicate;
import android.annotation.Nullable;
import android.content.ClipData;
import android.content.Context;
import android.content.Intent;
import android.content.res.ColorStateList;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.graphics.Bitmap;
import android.graphics.BlendMode;
import android.graphics.Canvas;
import android.graphics.Insets;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Point;
import android.graphics.PorterDuff;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.Region;
import android.graphics.RenderNode;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Parcel;
import android.os.Parcelable;
import android.util.AttributeSet;
import android.util.SparseArray;

public class View implements Drawable.Callback {
    public @interface Focusable {
    }

    public @interface Visibility {
    }

    public @interface AutofillType {
    }
    public @interface AutofillImportance {
    }
    public @interface AutofillFlags {
    }
    public @interface ContentCaptureImportance {
    }
    public @interface ScrollCaptureHint {
    }
    public @interface DrawingCacheQuality {
    }
    public @interface ScrollBarStyle {
    }
    public @interface FocusableMode {
    }
    public @interface FocusDirection {
    }
    public @interface FocusRealDirection {
    }
    public @interface LayoutDir {
    }
    public @interface ResolvedLayoutDir {
    }
    public @interface TextAlignment {
    }
    public @interface ScrollIndicators {
    }
    public @interface ViewStructureType {
    }
    public @interface FindViewFlags {
    }
    public @interface LayerType {
    }

    public View(Context context) {}

    public View(Context context, AttributeSet attrs) {}

    public View(Context context, AttributeSet attrs, int defStyleAttr) {}

    public View(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {}

    public int[] getAttributeResolutionStack(int attribute) {
        return null;
    }

    public Map<Integer, Integer> getAttributeSourceResourceMap() {
        return null;
    }

    public int getExplicitStyle() {
        return 0;
    }

    public final boolean isShowingLayoutBounds() {
        return false;
    }

    public final void setShowingLayoutBounds(boolean debugLayout) {}

    public final void saveAttributeDataForStyleable(Context context, int[] styleable,
            AttributeSet attrs, TypedArray t, int defStyleAttr, int defStyleRes) {}

    @Override
    public String toString() {
        return null;
    }

    public int getVerticalFadingEdgeLength() {
        return 0;
    }

    public void setFadingEdgeLength(int length) {}

    public int getHorizontalFadingEdgeLength() {
        return 0;
    }

    public int getVerticalScrollbarWidth() {
        return 0;
    }

    public void setVerticalScrollbarThumbDrawable(Drawable drawable) {}

    public void setVerticalScrollbarTrackDrawable(Drawable drawable) {}

    public void setHorizontalScrollbarThumbDrawable(Drawable drawable) {}

    public void setHorizontalScrollbarTrackDrawable(Drawable drawable) {}

    public Drawable getVerticalScrollbarThumbDrawable() {
        return null;
    }

    public Drawable getVerticalScrollbarTrackDrawable() {
        return null;
    }

    public Drawable getHorizontalScrollbarThumbDrawable() {
        return null;
    }

    public Drawable getHorizontalScrollbarTrackDrawable() {
        return null;
    }

    public void setVerticalScrollbarPosition(int position) {}

    public int getVerticalScrollbarPosition() {
        return 0;
    }

    public void setScrollIndicators(int indicators) {}

    public void setScrollIndicators(int indicators, int mask) {}

    public int getScrollIndicators() {
        return 0;
    }

    public void setOnScrollChangeListener(OnScrollChangeListener l) {}

    public void setOnFocusChangeListener(OnFocusChangeListener l) {}

    public void addOnLayoutChangeListener(OnLayoutChangeListener listener) {}

    public void removeOnLayoutChangeListener(OnLayoutChangeListener listener) {}

    public void addOnAttachStateChangeListener(OnAttachStateChangeListener listener) {}

    public void removeOnAttachStateChangeListener(OnAttachStateChangeListener listener) {}

    public OnFocusChangeListener getOnFocusChangeListener() {
        return null;
    }

    public void setOnClickListener(OnClickListener l) {}

    public boolean hasOnClickListeners() {
        return false;
    }

    public void setOnLongClickListener(OnLongClickListener l) {}

    public boolean hasOnLongClickListeners() {
        return false;
    }

    public OnLongClickListener getOnLongClickListener() {
        return null;
    }

    public void setOnContextClickListener(OnContextClickListener l) {}

    public void setNotifyAutofillManagerOnClick(boolean notify) {}

    public boolean performClick() {
        return false;
    }

    public boolean callOnClick() {
        return false;
    }

    public boolean performLongClick() {
        return false;
    }

    public boolean performLongClick(float x, float y) {
        return false;
    }

    public boolean performContextClick(float x, float y) {
        return false;
    }

    public boolean performContextClick() {
        return false;
    }

    public boolean showContextMenu() {
        return false;
    }

    public boolean showContextMenu(float x, float y) {
        return false;
    }

    public void startActivityForResult(Intent intent, int requestCode) {}

    public boolean dispatchActivityResult(String who, int requestCode, int resultCode,
            Intent data) {
        return false;
    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {}

    public final void setRevealOnFocusHint(boolean revealOnFocus) {}

    public final boolean getRevealOnFocusHint() {
        return false;
    }

    public void getHotspotBounds(Rect outRect) {}

    public boolean requestRectangleOnScreen(Rect rectangle) {
        return false;
    }

    public boolean requestRectangleOnScreen(Rect rectangle, boolean immediate) {
        return false;
    }

    public void clearFocus() {}

    public boolean hasFocus() {
        return false;
    }

    public boolean hasFocusable() {
        return false;
    }

    public boolean hasExplicitFocusable() {
        return false;
    }

    public void notifyEnterOrExitForAutoFillIfNeeded(boolean enter) {}

    public void setAccessibilityPaneTitle(CharSequence accessibilityPaneTitle) {}

    public CharSequence getAccessibilityPaneTitle() {
        return null;
    }

    public void sendAccessibilityEvent(int eventType) {}

    public void announceForAccessibility(CharSequence text) {}

    public void sendAccessibilityEventInternal(int eventType) {}

    public void getBoundsOnScreen(Rect outRect) {}

    public void getBoundsOnScreen(Rect outRect, boolean clipToParent) {}

    public void mapRectFromViewToScreenCoords(RectF rect, boolean clipToParent) {}

    public CharSequence getAccessibilityClassName() {
        return null;
    }

    public int getAutofillType() {
        return 0;
    }

    @Nullable
    public String[] getAutofillHints() {
        return null;
    }

    public boolean isAutofilled() {
        return false;
    }

    public boolean hideAutofillHighlight() {
        return false;
    }

    public int getImportantForAutofill() {
        return 0;
    }

    public void setImportantForAutofill(int mode) {}

    public final boolean isImportantForAutofill() {
        return false;
    }

    public int getImportantForContentCapture() {
        return 0;
    }

    public void setImportantForContentCapture(int mode) {}

    public final boolean isImportantForContentCapture() {
        return false;
    }

    public boolean canNotifyAutofillEnterExitEvent() {
        return false;
    }

    public void dispatchInitialProvideContentCaptureStructure() {}

    public boolean isVisibleToUserForAutofill(int virtualId) {
        return false;
    }

    public boolean isVisibleToUser() {
        return false;
    }

    public AccessibilityDelegate getAccessibilityDelegate() {
        return null;
    }

    public void setAccessibilityDelegate(AccessibilityDelegate delegate) {}

    public int getAccessibilityViewId() {
        return 0;
    }

    public int getAutofillViewId() {
        return 0;
    }

    public int getAccessibilityWindowId() {
        return 0;
    }

    public final CharSequence getStateDescription() {
        return null;
    }

    public CharSequence getContentDescription() {
        return null;
    }

    public void setStateDescription(CharSequence stateDescription) {}

    public void setContentDescription(CharSequence contentDescription) {}

    public void setAccessibilityTraversalBefore(int beforeId) {}

    public int getAccessibilityTraversalBefore() {
        return 0;
    }

    public void setAccessibilityTraversalAfter(int afterId) {}

    public int getAccessibilityTraversalAfter() {
        return 0;
    }

    public int getLabelFor() {
        return 0;
    }

    public void setLabelFor(int id) {}

    public boolean isFocused() {
        return false;
    }

    public View findFocus() {
        return null;
    }

    public boolean isScrollContainer() {
        return false;
    }

    public void setScrollContainer(boolean isScrollContainer) {}

    public int getDrawingCacheQuality() {
        return 0;
    }

    public void setDrawingCacheQuality(int quality) {}

    public boolean getKeepScreenOn() {
        return false;
    }

    public void setKeepScreenOn(boolean keepScreenOn) {}

    public int getNextFocusLeftId() {
        return 0;
    }

    public void setNextFocusLeftId(int nextFocusLeftId) {}

    public int getNextFocusRightId() {
        return 0;
    }

    public void setNextFocusRightId(int nextFocusRightId) {}

    public int getNextFocusUpId() {
        return 0;
    }

    public void setNextFocusUpId(int nextFocusUpId) {}

    public int getNextFocusDownId() {
        return 0;
    }

    public void setNextFocusDownId(int nextFocusDownId) {}

    public int getNextFocusForwardId() {
        return 0;
    }

    public void setNextFocusForwardId(int nextFocusForwardId) {}

    public int getNextClusterForwardId() {
        return 0;
    }

    public void setNextClusterForwardId(int nextClusterForwardId) {}

    public boolean isShown() {
        return false;
    }

    public boolean hasWindowInsetsAnimationCallback() {
        return false;
    }

    public void setSystemGestureExclusionRects(List<Rect> rects) {}

    public List<Rect> getSystemGestureExclusionRects() {
        return null;
    }

    public void getLocationInSurface(int[] location) {}

    public void setFitsSystemWindows(boolean fitSystemWindows) {}

    public boolean getFitsSystemWindows() {
        return false;
    }

    public boolean fitsSystemWindows() {
        return false;
    }

    public void requestFitSystemWindows() {}

    public void requestApplyInsets() {}

    public void makeOptionalFitsSystemWindows() {}

    public void makeFrameworkOptionalFitsSystemWindows() {}

    public boolean isFrameworkOptionalFitsSystemWindows() {
        return false;
    }

    public int getVisibility() {
        return 0;
    }

    public void setVisibility(int visibility) {}

    public boolean isEnabled() {
        return false;
    }

    public void setEnabled(boolean enabled) {}

    public void setFocusable(boolean focusable) {}

    public void setFocusable(int focusable) {}

    public void setFocusableInTouchMode(boolean focusableInTouchMode) {}

    public void setAutofillHints(String... autofillHints) {}

    public void setAutofilled(boolean isAutofilled, boolean hideHighlight) {}

    public void setSoundEffectsEnabled(boolean soundEffectsEnabled) {}

    public boolean isSoundEffectsEnabled() {
        return false;
    }

    public void setHapticFeedbackEnabled(boolean hapticFeedbackEnabled) {}

    public boolean isHapticFeedbackEnabled() {
        return false;
    }

    public int getRawLayoutDirection() {
        return 0;
    }

    public void setLayoutDirection(int layoutDirection) {}

    public int getLayoutDirection() {
        return 0;
    }

    public boolean isLayoutRtl() {
        return false;
    }

    public boolean hasTransientState() {
        return false;
    }

    public void setHasTransientState(boolean hasTransientState) {}

    public boolean isAttachedToWindow() {
        return false;
    }

    public boolean isLaidOut() {
        return false;
    }

    public void setWillNotDraw(boolean willNotDraw) {}

    public boolean willNotDraw() {
        return false;
    }

    public void setWillNotCacheDrawing(boolean willNotCacheDrawing) {}

    public boolean willNotCacheDrawing() {
        return false;
    }

    public boolean isClickable() {
        return false;
    }

    public void setClickable(boolean clickable) {}

    public boolean isLongClickable() {
        return false;
    }

    public void setLongClickable(boolean longClickable) {}

    public boolean isContextClickable() {
        return false;
    }

    public void setContextClickable(boolean contextClickable) {}

    public void setPressed(boolean pressed) {}

    public boolean isPressed() {
        return false;
    }

    public boolean isAssistBlocked() {
        return false;
    }

    public void setAssistBlocked(boolean enabled) {}

    public boolean isSaveEnabled() {
        return false;
    }

    public void setSaveEnabled(boolean enabled) {}

    public boolean getFilterTouchesWhenObscured() {
        return false;
    }

    public void setFilterTouchesWhenObscured(boolean enabled) {}

    public boolean isSaveFromParentEnabled() {
        return false;
    }

    public void setSaveFromParentEnabled(boolean enabled) {}

    public final boolean isFocusable() {
        return false;
    }

    public int getFocusable() {
        return 0;
    }

    public final boolean isFocusableInTouchMode() {
        return false;
    }

    public boolean isScreenReaderFocusable() {
        return false;
    }

    public void setScreenReaderFocusable(boolean screenReaderFocusable) {}

    public boolean isAccessibilityHeading() {
        return false;
    }

    public void setAccessibilityHeading(boolean isHeading) {}

    public View focusSearch(int direction) {
        return null;
    }

    public final boolean isKeyboardNavigationCluster() {
        return false;
    }

    public void setKeyboardNavigationCluster(boolean isCluster) {}

    public final void setFocusedInCluster() {}

    public final boolean isFocusedByDefault() {
        return false;
    }

    public void setFocusedByDefault(boolean isFocusedByDefault) {}

    public View keyboardNavigationClusterSearch(View currentCluster, int direction) {
        return null;
    }

    public boolean dispatchUnhandledMove(View focused, int direction) {
        return false;
    }

    public void setDefaultFocusHighlightEnabled(boolean defaultFocusHighlightEnabled) {}

    public final boolean getDefaultFocusHighlightEnabled() {
        return false;
    }

    public ArrayList<View> getFocusables(int direction) {
        return null;
    }

    public void addFocusables(ArrayList<View> views, int direction) {}

    public void addFocusables(ArrayList<View> views, int direction, int focusableMode) {}

    public void addKeyboardNavigationClusters(Collection<View> views, int direction) {}

    public void findViewsWithText(ArrayList<View> outViews, CharSequence searched, int flags) {}

    public ArrayList<View> getTouchables() {
        return null;
    }

    public void addTouchables(ArrayList<View> views) {}

    public boolean isAccessibilityFocused() {
        return false;
    }

    public boolean requestAccessibilityFocus() {
        return false;
    }

    public void clearAccessibilityFocus() {}

    public final boolean requestFocus() {
        return false;
    }

    public boolean restoreFocusInCluster(int direction) {
        return false;
    }

    public boolean restoreFocusNotInCluster() {
        return false;
    }

    public boolean restoreDefaultFocus() {
        return false;
    }

    public final boolean requestFocus(int direction) {
        return false;
    }

    public boolean requestFocus(int direction, Rect previouslyFocusedRect) {
        return false;
    }

    public final boolean requestFocusFromTouch() {
        return false;
    }

    public int getImportantForAccessibility() {
        return 0;
    }

    public void setAccessibilityLiveRegion(int mode) {}

    public int getAccessibilityLiveRegion() {
        return 0;
    }

    public void setImportantForAccessibility(int mode) {}

    public boolean isImportantForAccessibility() {
        return false;
    }

    public void addChildrenForAccessibility(ArrayList<View> outChildren) {}

    public boolean includeForAccessibility() {
        return false;
    }

    public boolean isActionableForAccessibility() {
        return false;
    }

    public void notifyViewAccessibilityStateChangedIfNeeded(int changeType) {}

    public void notifySubtreeAccessibilityStateChangedIfNeeded() {}

    public void setTransitionVisibility(int visibility) {}

    public boolean dispatchNestedPrePerformAccessibilityAction(int action, Bundle arguments) {
        return false;
    }

    public boolean performAccessibilityAction(int action, Bundle arguments) {
        return false;
    }

    public boolean performAccessibilityActionInternal(int action, Bundle arguments) {
        return false;
    }

    public CharSequence getIterableTextForAccessibility() {
        return null;
    }

    public boolean isAccessibilitySelectionExtendable() {
        return false;
    }

    public int getAccessibilitySelectionStart() {
        return 0;
    }

    public int getAccessibilitySelectionEnd() {
        return 0;
    }

    public void setAccessibilitySelection(int start, int end) {}

    public final boolean isTemporarilyDetached() {
        return false;
    }

    public void dispatchStartTemporaryDetach() {}

    public void onStartTemporaryDetach() {}

    public void dispatchFinishTemporaryDetach() {}

    public void onFinishTemporaryDetach() {}

    public void dispatchWindowFocusChanged(boolean hasFocus) {}

    public void onWindowFocusChanged(boolean hasWindowFocus) {}

    public boolean hasWindowFocus() {
        return false;
    }

    public boolean hasImeFocus() {
        return false;
    }

    public void dispatchDisplayHint(int hint) {}

    public void dispatchWindowVisibilityChanged(int visibility) {}

    public void onVisibilityAggregated(boolean isVisible) {}

    public int getWindowVisibility() {
        return 0;
    }

    public void getWindowVisibleDisplayFrame(Rect outRect) {}

    public void getWindowDisplayFrame(Rect outRect) {}

    public void dispatchConfigurationChanged(Configuration newConfig) {}

    public boolean isInTouchMode() {
        return false;
    }

    public final Context getContext() {
        return null;
    }

    public boolean onCheckIsTextEditor() {
        return false;
    }

    public boolean checkInputConnectionProxy(View view) {
        return false;
    }

    public boolean isHovered() {
        return false;
    }

    public void setHovered(boolean hovered) {}

    public void onHoverChanged(boolean hovered) {}

    public boolean isInScrollingContainer() {
        return false;
    }

    public void cancelLongPress() {}

    public final void requestUnbufferedDispatch(int source) {}

    public void bringToFront() {}

    public interface OnScrollChangeListener {
        void onScrollChange(View v, int scrollX, int scrollY, int oldScrollX, int oldScrollY);

    }
    public interface OnLayoutChangeListener {
        void onLayoutChange(View v, int left, int top, int right, int bottom, int oldLeft,
                int oldTop, int oldRight, int oldBottom);

    }

    public void setScrollX(int value) {}

    public void setScrollY(int value) {}

    public final int getScrollX() {
        return 0;
    }

    public final int getScrollY() {
        return 0;
    }

    public final int getWidth() {
        return 0;
    }

    public final int getHeight() {
        return 0;
    }

    public void getDrawingRect(Rect outRect) {}

    public final int getMeasuredWidth() {
        return 0;
    }

    public final int getMeasuredWidthAndState() {
        return 0;
    }

    public final int getMeasuredHeight() {
        return 0;
    }

    public final int getMeasuredHeightAndState() {
        return 0;
    }

    public final int getMeasuredState() {
        return 0;
    }

    public Matrix getMatrix() {
        return null;
    }

    public final boolean hasIdentityMatrix() {
        return false;
    }

    public final Matrix getInverseMatrix() {
        return null;
    }

    public float getCameraDistance() {
        return 0;
    }

    public void setCameraDistance(float distance) {}

    public float getRotation() {
        return 0;
    }

    public void setRotation(float rotation) {}

    public float getRotationY() {
        return 0;
    }

    public void setRotationY(float rotationY) {}

    public float getRotationX() {
        return 0;
    }

    public void setRotationX(float rotationX) {}

    public float getScaleX() {
        return 0;
    }

    public void setScaleX(float scaleX) {}

    public float getScaleY() {
        return 0;
    }

    public void setScaleY(float scaleY) {}

    public float getPivotX() {
        return 0;
    }

    public void setPivotX(float pivotX) {}

    public float getPivotY() {
        return 0;
    }

    public void setPivotY(float pivotY) {}

    public boolean isPivotSet() {
        return false;
    }

    public void resetPivot() {}

    public float getAlpha() {
        return 0;
    }

    public void forceHasOverlappingRendering(boolean hasOverlappingRendering) {}

    public final boolean getHasOverlappingRendering() {
        return false;
    }

    public boolean hasOverlappingRendering() {
        return false;
    }

    public void setAlpha(float alpha) {}

    public void setTransitionAlpha(float alpha) {}

    public float getTransitionAlpha() {
        return 0;
    }

    public void setForceDarkAllowed(boolean allow) {}

    public boolean isForceDarkAllowed() {
        return false;
    }

    public final int getTop() {
        return 0;
    }

    public final void setTop(int top) {}

    public final int getBottom() {
        return 0;
    }

    public boolean isDirty() {
        return false;
    }

    public final void setBottom(int bottom) {}

    public final int getLeft() {
        return 0;
    }

    public final void setLeft(int left) {}

    public final int getRight() {
        return 0;
    }

    public final void setRight(int right) {}

    public float getX() {
        return 0;
    }

    public void setX(float x) {}

    public float getY() {
        return 0;
    }

    public void setY(float y) {}

    public float getZ() {
        return 0;
    }

    public void setZ(float z) {}

    public float getElevation() {
        return 0;
    }

    public void setElevation(float elevation) {}

    public float getTranslationX() {
        return 0;
    }

    public void setTranslationX(float translationX) {}

    public float getTranslationY() {
        return 0;
    }

    public void setTranslationY(float translationY) {}

    public float getTranslationZ() {
        return 0;
    }

    public void setTranslationZ(float translationZ) {}

    public void setAnimationMatrix(Matrix matrix) {}

    public Matrix getAnimationMatrix() {
        return null;
    }

    public final boolean getClipToOutline() {
        return false;
    }

    public void setClipToOutline(boolean clipToOutline) {}

    public void invalidateOutline() {}

    public boolean hasShadow() {
        return false;
    }

    public void setOutlineSpotShadowColor(int color) {}

    public int getOutlineSpotShadowColor() {
        return 0;
    }

    public void setOutlineAmbientShadowColor(int color) {}

    public int getOutlineAmbientShadowColor() {
        return 0;
    }

    public void setRevealClip(boolean shouldClip, float x, float y, float radius) {}

    public void getHitRect(Rect outRect) {}

    public boolean pointInView(float localX, float localY, float slop) {
        return false;
    }

    public void getFocusedRect(Rect r) {}

    public boolean getGlobalVisibleRect(Rect r, Point globalOffset) {
        return false;
    }

    public final boolean getGlobalVisibleRect(Rect r) {
        return false;
    }

    public final boolean getLocalVisibleRect(Rect r) {
        return false;
    }

    public void offsetTopAndBottom(int offset) {}

    public void offsetLeftAndRight(int offset) {}

    public void resolveLayoutParams() {}

    public void scrollTo(int x, int y) {}

    public void scrollBy(int x, int y) {}

    public void invalidate(Rect dirty) {}

    public void invalidate(int l, int t, int r, int b) {}

    public void invalidate() {}

    public void invalidate(boolean invalidateCache) {}

    public boolean isOpaque() {
        return false;
    }

    public Handler getHandler() {
        return null;
    }

    public boolean post(Runnable action) {
        return false;
    }

    public boolean postDelayed(Runnable action, long delayMillis) {
        return false;
    }

    public void postOnAnimation(Runnable action) {}

    public void postOnAnimationDelayed(Runnable action, long delayMillis) {}

    public boolean removeCallbacks(Runnable action) {
        return false;
    }

    public void postInvalidate() {}

    public void postInvalidate(int left, int top, int right, int bottom) {}

    public void postInvalidateDelayed(long delayMilliseconds) {}

    public void postInvalidateDelayed(long delayMilliseconds, int left, int top, int right,
            int bottom) {}

    public void postInvalidateOnAnimation() {}

    public void postInvalidateOnAnimation(int left, int top, int right, int bottom) {}

    public void computeScroll() {}

    public boolean isHorizontalFadingEdgeEnabled() {
        return false;
    }

    public void setHorizontalFadingEdgeEnabled(boolean horizontalFadingEdgeEnabled) {}

    public boolean isVerticalFadingEdgeEnabled() {
        return false;
    }

    public void setVerticalFadingEdgeEnabled(boolean verticalFadingEdgeEnabled) {}

    public int getFadingEdge() {
        return 0;
    }

    public int getFadingEdgeLength() {
        return 0;
    }

    public boolean isHorizontalScrollBarEnabled() {
        return false;
    }

    public void setHorizontalScrollBarEnabled(boolean horizontalScrollBarEnabled) {}

    public boolean isVerticalScrollBarEnabled() {
        return false;
    }

    public void setVerticalScrollBarEnabled(boolean verticalScrollBarEnabled) {}

    public void setScrollbarFadingEnabled(boolean fadeScrollbars) {}

    public boolean isScrollbarFadingEnabled() {
        return false;
    }

    public int getScrollBarDefaultDelayBeforeFade() {
        return 0;
    }

    public void setScrollBarDefaultDelayBeforeFade(int scrollBarDefaultDelayBeforeFade) {}

    public int getScrollBarFadeDuration() {
        return 0;
    }

    public void setScrollBarFadeDuration(int scrollBarFadeDuration) {}

    public int getScrollBarSize() {
        return 0;
    }

    public void setScrollBarSize(int scrollBarSize) {}

    public void setScrollBarStyle(int style) {}

    public int getScrollBarStyle() {
        return 0;
    }

    public boolean canScrollHorizontally(int direction) {
        return false;
    }

    public boolean canScrollVertically(int direction) {
        return false;
    }

    public boolean resolveRtlPropertiesIfNeeded() {
        return false;
    }

    public void resetRtlProperties() {}

    public void onScreenStateChanged(int screenState) {}

    public void onMovedToDisplay(int displayId, Configuration config) {}

    public void onRtlPropertiesChanged(int layoutDirection) {}

    public boolean resolveLayoutDirection() {
        return false;
    }

    public boolean canResolveLayoutDirection() {
        return false;
    }

    public void resetResolvedLayoutDirection() {}

    public boolean isLayoutDirectionInherited() {
        return false;
    }

    public boolean isLayoutDirectionResolved() {
        return false;
    }

    public void resolvePadding() {}

    public void resetResolvedPadding() {}

    public IBinder getWindowToken() {
        return null;
    }

    public IBinder getApplicationWindowToken() {
        return null;
    }

    public Display getDisplay() {
        return null;
    }

    public final void cancelPendingInputEvents() {}

    public void onCancelPendingInputEvents() {}

    public void saveHierarchyState(SparseArray<Parcelable> container) {}

    public void restoreHierarchyState(SparseArray<Parcelable> container) {}

    public long getDrawingTime() {
        return 0;
    }

    public void setDuplicateParentStateEnabled(boolean enabled) {}

    public boolean isDuplicateParentStateEnabled() {
        return false;
    }

    public void setLayerType(int layerType, Paint paint) {}

    public void setLayerPaint(Paint paint) {}

    public int getLayerType() {
        return 0;
    }

    public void buildLayer() {}

    public void setDrawingCacheEnabled(boolean enabled) {}

    public boolean isDrawingCacheEnabled() {
        return false;
    }

    public void outputDirtyFlags(String indent, boolean clear, int clearMask) {}

    public boolean canHaveDisplayList() {
        return false;
    }

    public RenderNode updateDisplayListIfDirty() {
        return null;
    }

    public Bitmap getDrawingCache() {
        return null;
    }

    public Bitmap getDrawingCache(boolean autoScale) {
        return null;
    }

    public void destroyDrawingCache() {}

    public void setDrawingCacheBackgroundColor(int color) {}

    public int getDrawingCacheBackgroundColor() {
        return 0;
    }

    public void buildDrawingCache() {}

    public void buildDrawingCache(boolean autoScale) {}

    public boolean isInEditMode() {
        return false;
    }

    public boolean isHardwareAccelerated() {
        return false;
    }

    public void setClipBounds(Rect clipBounds) {}

    public Rect getClipBounds() {
        return null;
    }

    public boolean getClipBounds(Rect outRect) {
        return false;
    }

    public void draw(Canvas canvas) {}

    public int getSolidColor() {
        return 0;
    }

    public boolean isLayoutRequested() {
        return false;
    }

    public static boolean isLayoutModeOptical(Object o) {
        return false;
    }

    public void layout(int l, int t, int r, int b) {}

    public final void setLeftTopRightBottom(int left, int top, int right, int bottom) {}

    public Resources getResources() {
        return null;
    }

    @Override
    public void invalidateDrawable(Drawable drawable) {}

    @Override
    public void scheduleDrawable(Drawable who, Runnable what, long when) {}

    @Override
    public void unscheduleDrawable(Drawable who, Runnable what) {}

    public void unscheduleDrawable(Drawable who) {}

    public void onResolveDrawables(int layoutDirection) {}

    public void drawableHotspotChanged(float x, float y) {}

    public void dispatchDrawableHotspotChanged(float x, float y) {}

    public void refreshDrawableState() {}

    public boolean isDefaultFocusHighlightNeeded(Drawable background, Drawable foreground) {
        return false;
    }

    public final int[] getDrawableState() {
        return null;
    }

    public void jumpDrawablesToCurrentState() {}

    public void setBackgroundColor(int color) {}

    public void setBackgroundResource(int resid) {}

    public void setBackground(Drawable background) {}

    public void setBackgroundDrawable(Drawable background) {}

    public Drawable getBackground() {
        return null;
    }

    public void setBackgroundTintList(ColorStateList tint) {}

    public ColorStateList getBackgroundTintList() {
        return null;
    }

    public void setBackgroundTintMode(PorterDuff.Mode tintMode) {}

    public void setBackgroundTintBlendMode(BlendMode blendMode) {}

    public PorterDuff.Mode getBackgroundTintMode() {
        return null;
    }

    public BlendMode getBackgroundTintBlendMode() {
        return null;
    }

    public Drawable getForeground() {
        return null;
    }

    public void setForeground(Drawable foreground) {}

    public boolean isForegroundInsidePadding() {
        return false;
    }

    public int getForegroundGravity() {
        return 0;
    }

    public void setForegroundGravity(int gravity) {}

    public void setForegroundTintList(ColorStateList tint) {}

    public ColorStateList getForegroundTintList() {
        return null;
    }

    public void setForegroundTintMode(PorterDuff.Mode tintMode) {}

    public void setForegroundTintBlendMode(BlendMode blendMode) {}

    public PorterDuff.Mode getForegroundTintMode() {
        return null;
    }

    public BlendMode getForegroundTintBlendMode() {
        return null;
    }

    public void onDrawForeground(Canvas canvas) {}

    public void setPadding(int left, int top, int right, int bottom) {}

    public void setPaddingRelative(int start, int top, int end, int bottom) {}

    public int getSourceLayoutResId() {
        return 0;
    }

    public int getPaddingTop() {
        return 0;
    }

    public int getPaddingBottom() {
        return 0;
    }

    public int getPaddingLeft() {
        return 0;
    }

    public int getPaddingStart() {
        return 0;
    }

    public int getPaddingRight() {
        return 0;
    }

    public int getPaddingEnd() {
        return 0;
    }

    public boolean isPaddingRelative() {
        return false;
    }

    public void resetPaddingToInitialValues() {}

    public Insets getOpticalInsets() {
        return null;
    }

    public void setOpticalInsets(Insets insets) {}

    public void setSelected(boolean selected) {}

    public boolean isSelected() {
        return false;
    }

    public void setActivated(boolean activated) {}

    public boolean isActivated() {
        return false;
    }

    public View getRootView() {
        return null;
    }

    public void transformMatrixToGlobal(Matrix matrix) {}

    public void transformMatrixToLocal(Matrix matrix) {}

    public int[] getLocationOnScreen() {
        return null;
    }

    public void getLocationOnScreen(int[] outLocation) {}

    public void getLocationInWindow(int[] outLocation) {}

    public void transformFromViewToWindowSpace(int[] inOutLocation) {}

    public final <T extends View> T findViewById(int id) {
        return null;
    }

    public final <T extends View> T requireViewById(int id) {
        return null;
    }

    public <T extends View> T findViewByAccessibilityIdTraversal(int accessibilityId) {
        return null;
    }

    public <T extends View> T findViewByAutofillIdTraversal(int autofillId) {
        return null;
    }

    public final <T extends View> T findViewWithTag(Object tag) {
        return null;
    }

    public final <T extends View> T findViewByPredicate(Predicate<View> predicate) {
        return null;
    }

    public final <T extends View> T findViewByPredicateInsideOut(View start,
            Predicate<View> predicate) {
        return null;
    }

    public void setId(int id) {}

    public void setIsRootNamespace(boolean isRoot) {}

    public boolean isRootNamespace() {
        return false;
    }

    public int getId() {
        return 0;
    }

    public long getUniqueDrawingId() {
        return 0;
    }

    public Object getTag() {
        return null;
    }

    public void setTag(final Object tag) {}

    public Object getTag(int key) {
        return null;
    }

    public void setTag(int key, final Object tag) {}

    public void setTagInternal(int key, Object tag) {}

    public void debug() {}

    public int getBaseline() {
        return 0;
    }

    public boolean isInLayout() {
        return false;
    }

    public void requestLayout() {}

    public void forceLayout() {}

    public final void measure(int widthMeasureSpec, int heightMeasureSpec) {}

    public static int combineMeasuredStates(int curState, int newState) {
        return 0;
    }

    public static int resolveSize(int size, int measureSpec) {
        return 0;
    }

    public static int resolveSizeAndState(int size, int measureSpec, int childMeasuredState) {
        return 0;
    }

    public static int getDefaultSize(int size, int measureSpec) {
        return 0;
    }

    public int getMinimumHeight() {
        return 0;
    }

    public void setMinimumHeight(int minHeight) {}

    public int getMinimumWidth() {
        return 0;
    }

    public void setMinimumWidth(int minWidth) {}

    public void clearAnimation() {}

    public boolean gatherTransparentRegion(Region region) {
        return false;
    }

    public void playSoundEffect(int soundConstant) {}

    public boolean performHapticFeedback(int feedbackConstant) {
        return false;
    }

    public boolean performHapticFeedback(int feedbackConstant, int flags) {
        return false;
    }

    public void setSystemUiVisibility(int visibility) {}

    public int getSystemUiVisibility() {
        return 0;
    }

    public int getWindowSystemUiVisibility() {
        return 0;
    }

    public void onWindowSystemUiVisibilityChanged(int visible) {}

    public void dispatchWindowSystemUiVisiblityChanged(int visible) {}

    public void setOnSystemUiVisibilityChangeListener(OnSystemUiVisibilityChangeListener l) {}

    public void dispatchSystemUiVisibilityChanged(int visibility) {}

    public void setDisabledSystemUiVisibility(int flags) {}

    public static class DragShadowBuilder {
        public DragShadowBuilder(View view) {}

        public DragShadowBuilder() {}

        final public View getView() {
            return null;
        }

        public void onProvideShadowMetrics(Point outShadowSize, Point outShadowTouchPoint) {}

        public void onDrawShadow(Canvas canvas) {}

    }

    public final boolean startDrag(ClipData data, DragShadowBuilder shadowBuilder,
            Object myLocalState, int flags) {
        return false;
    }

    public final boolean startDragAndDrop(ClipData data, DragShadowBuilder shadowBuilder,
            Object myLocalState, int flags) {
        return false;
    }

    public final void cancelDragAndDrop() {}

    public final void updateDragShadow(DragShadowBuilder shadowBuilder) {}

    public final boolean startMovingTask(float startX, float startY) {
        return false;
    }

    public void finishMovingTask() {}


    public void onCloseSystemDialogs(String reason) {}

    public void applyDrawableToTransparentRegion(Drawable dr, Region region) {}

    public int getOverScrollMode() {
        return 0;
    }

    public void setOverScrollMode(int overScrollMode) {}

    public void setNestedScrollingEnabled(boolean enabled) {}

    public boolean isNestedScrollingEnabled() {
        return false;
    }

    public boolean startNestedScroll(int axes) {
        return false;
    }

    public void stopNestedScroll() {}

    public boolean hasNestedScrollingParent() {
        return false;
    }

    public boolean dispatchNestedScroll(int dxConsumed, int dyConsumed, int dxUnconsumed,
            int dyUnconsumed, int[] offsetInWindow) {
        return false;
    }

    public boolean dispatchNestedPreScroll(int dx, int dy, int[] consumed, int[] offsetInWindow) {
        return false;
    }

    public boolean dispatchNestedFling(float velocityX, float velocityY, boolean consumed) {
        return false;
    }

    public boolean dispatchNestedPreFling(float velocityX, float velocityY) {
        return false;
    }

    public int getRawTextDirection() {
        return 0;
    }

    public void setTextDirection(int textDirection) {}

    public int getTextDirection() {
        return 0;
    }

    public boolean resolveTextDirection() {
        return false;
    }

    public boolean canResolveTextDirection() {
        return false;
    }

    public void resetResolvedTextDirection() {}

    public boolean isTextDirectionInherited() {
        return false;
    }

    public boolean isTextDirectionResolved() {
        return false;
    }

    public int getRawTextAlignment() {
        return 0;
    }

    public void setTextAlignment(int textAlignment) {}

    public int getTextAlignment() {
        return 0;
    }

    public boolean resolveTextAlignment() {
        return false;
    }

    public boolean canResolveTextAlignment() {
        return false;
    }

    public void resetResolvedTextAlignment() {}

    public boolean isTextAlignmentInherited() {
        return false;
    }

    public boolean isTextAlignmentResolved() {
        return false;
    }

    public static int generateViewId() {
        return 0;
    }

    public void captureTransitioningViews(List<View> transitioningViews) {}

    public void findNamedViews(Map<String, View> namedElements) {}

    public boolean hasPointerCapture() {
        return false;
    }

    public void requestPointerCapture() {}

    public void releasePointerCapture() {}

    public void onPointerCaptureChange(boolean hasCapture) {}

    public void dispatchPointerCaptureChanged(boolean hasCapture) {}

    public static class MeasureSpec {
        public @interface MeasureSpecMode {
        }

        public static int makeMeasureSpec(int size, int mode) {
            return 0;
        }

        public static int makeSafeMeasureSpec(int size, int mode) {
            return 0;
        }

        public static int getMode(int measureSpec) {
            return 0;
        }

        public static int getSize(int measureSpec) {
            return 0;
        }

        public static String toString(int measureSpec) {
            return null;
        }

    }

    public final void setTransitionName(String transitionName) {}

    public String getTransitionName() {
        return null;
    }

    public interface OnLongClickListener {
        boolean onLongClick(View v);

    }

    public interface OnFocusChangeListener {
        void onFocusChange(View v, boolean hasFocus);

    }
    public interface OnClickListener {
        void onClick(View v);
    }
    public interface OnContextClickListener {
        boolean onContextClick(View v);

    }

    public interface OnSystemUiVisibilityChangeListener {
        public void onSystemUiVisibilityChange(int visibility);

    }
    public interface OnAttachStateChangeListener {
        public void onViewAttachedToWindow(View v);

        public void onViewDetachedFromWindow(View v);

    }

    public static class BaseSavedState {
        public BaseSavedState(Parcel source) {}

        public BaseSavedState(Parcel source, ClassLoader loader) {}

        public BaseSavedState(Parcelable superState) {}

        public void writeToParcel(Parcel out, int flags) {}

    }
    public static class AccessibilityDelegate {
        public void sendAccessibilityEvent(View host, int eventType) {}

        public boolean performAccessibilityAction(View host, int action, Bundle args) {
            return false;
        }
    }

    public int getScrollCaptureHint() {
        return 0;
    }

    public void setScrollCaptureHint(int hint) {}

    public void setTooltipText(CharSequence tooltipText) {}

    public void setTooltip(CharSequence tooltipText) {}

    public CharSequence getTooltipText() {
        return null;
    }

    public CharSequence getTooltip() {
        return null;
    }

    public View getTooltipView() {
        return null;
    }

    public static boolean isDefaultFocusHighlightEnabled() {
        return false;
    }
}
