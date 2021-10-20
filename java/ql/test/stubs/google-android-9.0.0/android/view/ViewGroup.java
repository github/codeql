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
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.Region;
import android.os.Bundle;
import android.util.AttributeSet;

public abstract class ViewGroup extends View {
  public ViewGroup(Context context) {
    super(null);
  }

  public ViewGroup(Context context, AttributeSet attrs) {
    super(null);
  }

  public ViewGroup(Context context, AttributeSet attrs, int defStyleAttr) {
    super(null);
  }

  public ViewGroup(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
    super(null);
  }

  public int getDescendantFocusability() {
    return 0;
  }

  public void setDescendantFocusability(int focusability) {}

  public void requestChildFocus(View child, View focused) {}

  public void focusableViewAvailable(View v) {}

  public boolean showContextMenuForChild(View originalView) {
    return false;
  }

  public final boolean isShowingContextMenuWithCoords() {
    return false;
  }

  public boolean showContextMenuForChild(View originalView, float x, float y) {
    return false;
  }

  public boolean dispatchActivityResult(String who, int requestCode, int resultCode, Intent data) {
    return false;
  }

  public View focusSearch(View focused, int direction) {
    return null;
  }

  public boolean requestChildRectangleOnScreen(View child, Rect rectangle, boolean immediate) {
    return false;
  }

  public void childHasTransientStateChanged(View child, boolean childHasTransientState) {}

  public boolean hasTransientState() {
    return false;
  }

  public boolean dispatchUnhandledMove(View focused, int direction) {
    return false;
  }

  public void clearChildFocus(View child) {}

  public void clearFocus() {}

  public View getFocusedChild() {
    return null;
  }

  public boolean hasFocus() {
    return false;
  }

  public View findFocus() {
    return null;
  }

  public void addFocusables(ArrayList<View> views, int direction, int focusableMode) {}

  public void addKeyboardNavigationClusters(Collection<View> views, int direction) {}

  public void setTouchscreenBlocksFocus(boolean touchscreenBlocksFocus) {}

  public boolean getTouchscreenBlocksFocus() {
    return false;
  }

  public void findViewsWithText(ArrayList<View> outViews, CharSequence text, int flags) {}

  public View findViewByAccessibilityIdTraversal(int accessibilityId) {
    return null;
  }

  public View findViewByAutofillIdTraversal(int autofillId) {
    return null;
  }

  public void dispatchWindowFocusChanged(boolean hasFocus) {}

  public void addTouchables(ArrayList<View> views) {}

  public void makeOptionalFitsSystemWindows() {}

  public void makeFrameworkOptionalFitsSystemWindows() {}

  public void dispatchDisplayHint(int hint) {}

  public void dispatchWindowVisibilityChanged(int visibility) {}

  public void dispatchConfigurationChanged(Configuration newConfig) {}

  public void recomputeViewAttributes(View child) {}

  public void bringChildToFront(View child) {}

  public void dispatchWindowSystemUiVisiblityChanged(int visible) {}

  public void dispatchSystemUiVisibilityChanged(int visible) {}

  public void dispatchPointerCaptureChanged(boolean hasCapture) {}

  public void addChildrenForAccessibility(ArrayList<View> outChildren) {}

  public ArrayList<View> buildTouchDispatchChildList() {
    return null;
  }

  public void transformPointToViewLocal(float[] point, View child) {}

  public void setMotionEventSplittingEnabled(boolean split) {}

  public boolean isMotionEventSplittingEnabled() {
    return false;
  }

  public boolean isTransitionGroup() {
    return false;
  }

  public void setTransitionGroup(boolean isTransitionGroup) {}

  public void requestDisallowInterceptTouchEvent(boolean disallowIntercept) {}

  public boolean requestFocus(int direction, Rect previouslyFocusedRect) {
    return false;
  }

  public boolean restoreDefaultFocus() {
    return false;
  }

  public boolean restoreFocusInCluster(int direction) {
    return false;
  }

  public boolean restoreFocusNotInCluster() {
    return false;
  }

  public void dispatchStartTemporaryDetach() {}

  public void dispatchFinishTemporaryDetach() {}

  public void dispatchProvideContentCaptureStructure() {}

  public CharSequence getAccessibilityClassName() {
    return null;
  }

  public void notifySubtreeAccessibilityStateChanged(View child, View source, int changeType) {}

  public void notifySubtreeAccessibilityStateChangedIfNeeded() {}

  public boolean onNestedPrePerformAccessibilityAction(View target, int action, Bundle args) {
    return false;
  }

  public final int getChildDrawingOrder(int drawingPosition) {
    return 0;
  }

  public boolean getClipChildren() {
    return false;
  }

  public void setClipChildren(boolean clipChildren) {}

  public void setClipToPadding(boolean clipToPadding) {}

  public boolean getClipToPadding() {
    return false;
  }

  public void dispatchSetSelected(boolean selected) {}

  public void dispatchSetActivated(boolean activated) {}

  public void dispatchDrawableHotspotChanged(float x, float y) {}

  public void addTransientView(View view, int index) {}

  public void removeTransientView(View view) {}

  public int getTransientViewCount() {
    return 0;
  }

  public int getTransientViewIndex(int position) {
    return 0;
  }

  public View getTransientView(int position) {
    return null;
  }

  public void addView(View child) {}

  public void addView(View child, int index) {}

  public void addView(View child, int width, int height) {}

  public void addView(View child, LayoutParams params) {}

  public void addView(View child, int index, LayoutParams params) {}

  public void updateViewLayout(View view, ViewGroup.LayoutParams params) {}

  public interface OnHierarchyChangeListener {
    void onChildViewAdded(View parent, View child);

    void onChildViewRemoved(View parent, View child);

  }

  public void setOnHierarchyChangeListener(OnHierarchyChangeListener listener) {}

  public void onViewAdded(View child) {}

  public void onViewRemoved(View child) {}

  public void removeView(View view) {}

  public void removeViewInLayout(View view) {}

  public void removeViewsInLayout(int start, int count) {}

  public void removeViewAt(int index) {}

  public void removeViews(int start, int count) {}

  public void removeAllViews() {}

  public void removeAllViewsInLayout() {}

  public void onDescendantInvalidated(View child, View target) {}

  public final void invalidateChild(View child, final Rect dirty) {}

  public final void offsetDescendantRectToMyCoords(View descendant, Rect rect) {}

  public final void offsetRectIntoDescendantCoords(View descendant, Rect rect) {}

  public void offsetChildrenTopAndBottom(int offset) {}

  public boolean getChildVisibleRect(View child, Rect r, android.graphics.Point offset) {
    return false;
  }

  public boolean getChildVisibleRect(View child, Rect r, android.graphics.Point offset,
      boolean forceParentCheck) {
    return false;
  }

  public final void layout(int l, int t, int r, int b) {}

  public void startLayoutAnimation() {}

  public void scheduleLayoutAnimation() {}

  public boolean isAnimationCacheEnabled() {
    return false;
  }

  public void setAnimationCacheEnabled(boolean enabled) {}

  public boolean isAlwaysDrawnWithCacheEnabled() {
    return false;
  }

  public void setAlwaysDrawnWithCacheEnabled(boolean always) {}

  public int getPersistentDrawingCache() {
    return 0;
  }

  public void setPersistentDrawingCache(int drawingCacheToKeep) {}

  public int getLayoutMode() {
    return 0;
  }

  public void setLayoutMode(int layoutMode) {}

  public LayoutParams generateLayoutParams(AttributeSet attrs) {
    return null;
  }

  public int indexOfChild(View child) {
    return 0;
  }

  public int getChildCount() {
    return 0;
  }

  public View getChildAt(int index) {
    return null;
  }

  public static int getChildMeasureSpec(int spec, int padding, int childDimension) {
    return 0;
  }

  public void clearDisappearingChildren() {}

  public void startViewTransition(View view) {}

  public void endViewTransition(View view) {}

  public void suppressLayout(boolean suppress) {}

  public boolean isLayoutSuppressed() {
    return false;
  }

  public boolean gatherTransparentRegion(Region region) {
    return false;
  }

  public void requestTransparentRegion(View child) {}

  public void subtractObscuredTouchableRegion(Region touchableRegion, View view) {}

  public boolean hasWindowInsetsAnimationCallback() {
    return false;
  }

  public void jumpDrawablesToCurrentState() {}

  public void setAddStatesFromChildren(boolean addsStates) {}

  public boolean addStatesFromChildren() {
    return false;
  }

  public void childDrawableStateChanged(View child) {}

  public boolean resolveRtlPropertiesIfNeeded() {
    return false;
  }

  public boolean resolveLayoutDirection() {
    return false;
  }

  public boolean resolveTextDirection() {
    return false;
  }

  public boolean resolveTextAlignment() {
    return false;
  }

  public void resolvePadding() {}

  public void resolveLayoutParams() {}

  public void resetResolvedLayoutDirection() {}

  public void resetResolvedTextDirection() {}

  public void resetResolvedTextAlignment() {}

  public void resetResolvedPadding() {}

  public boolean shouldDelayChildPressedState() {
    return false;
  }

  public boolean onStartNestedScroll(View child, View target, int nestedScrollAxes) {
    return false;
  }

  public void onNestedScrollAccepted(View child, View target, int axes) {}

  public void onStopNestedScroll(View child) {}

  public void onNestedScroll(View target, int dxConsumed, int dyConsumed, int dxUnconsumed,
      int dyUnconsumed) {}

  public void onNestedPreScroll(View target, int dx, int dy, int[] consumed) {}

  public boolean onNestedFling(View target, float velocityX, float velocityY, boolean consumed) {
    return false;
  }

  public boolean onNestedPreFling(View target, float velocityX, float velocityY) {
    return false;
  }

  public int getNestedScrollAxes() {
    return 0;
  }

  public void captureTransitioningViews(List<View> transitioningViews) {}

  public void findNamedViews(Map<String, View> namedElements) {}

  public static class LayoutParams {
    public LayoutParams(Context c, AttributeSet attrs) {}

    public LayoutParams(int width, int height) {}

    public LayoutParams(LayoutParams source) {}

    public void resolveLayoutDirection(int layoutDirection) {}

    public String debug(String output) {
      return null;
    }

    public void onDebugDraw(View view, Canvas canvas, Paint paint) {}

  }
  public static class MarginLayoutParams extends ViewGroup.LayoutParams {
    public MarginLayoutParams(Context c, AttributeSet attrs) {
      super(null);
    }

    public MarginLayoutParams(int width, int height) {
      super(null);
    }

    public MarginLayoutParams(MarginLayoutParams source) {
      super(null);
    }

    public MarginLayoutParams(LayoutParams source) {
      super(null);
    }

    public final void copyMarginsFrom(MarginLayoutParams source) {}

    public void setMargins(int left, int top, int right, int bottom) {}

    public void setMarginsRelative(int start, int top, int end, int bottom) {}

    public void setMarginStart(int start) {}

    public int getMarginStart() {
      return 0;
    }

    public void setMarginEnd(int end) {}

    public int getMarginEnd() {
      return 0;
    }

    public boolean isMarginRelative() {
      return false;
    }

    public void setLayoutDirection(int layoutDirection) {}

    public int getLayoutDirection() {
      return 0;
    }

    public void resolveLayoutDirection(int layoutDirection) {}

    public boolean isLayoutRtl() {
      return false;
    }

    public void onDebugDraw(View view, Canvas canvas, Paint paint) {}

  }

  public final void onDescendantUnbufferedRequested() {}

}
