// Generated automatically from android.view.ViewParent for testing purposes

package android.view;

import android.graphics.Point;
import android.graphics.Rect;
import android.os.Bundle;
import android.view.ActionMode;
import android.view.ContextMenu;
import android.view.View;
import android.view.accessibility.AccessibilityEvent;

public interface ViewParent
{
    ActionMode startActionModeForChild(View p0, ActionMode.Callback p1);
    ActionMode startActionModeForChild(View p0, ActionMode.Callback p1, int p2);
    View focusSearch(View p0, int p1);
    View keyboardNavigationClusterSearch(View p0, int p1);
    ViewParent getParent();
    ViewParent getParentForAccessibility();
    ViewParent invalidateChildInParent(int[] p0, Rect p1);
    boolean canResolveLayoutDirection();
    boolean canResolveTextAlignment();
    boolean canResolveTextDirection();
    boolean getChildVisibleRect(View p0, Rect p1, Point p2);
    boolean isLayoutDirectionResolved();
    boolean isLayoutRequested();
    boolean isTextAlignmentResolved();
    boolean isTextDirectionResolved();
    boolean onNestedFling(View p0, float p1, float p2, boolean p3);
    boolean onNestedPreFling(View p0, float p1, float p2);
    boolean onNestedPrePerformAccessibilityAction(View p0, int p1, Bundle p2);
    boolean onStartNestedScroll(View p0, View p1, int p2);
    boolean requestChildRectangleOnScreen(View p0, Rect p1, boolean p2);
    boolean requestSendAccessibilityEvent(View p0, AccessibilityEvent p1);
    boolean showContextMenuForChild(View p0);
    boolean showContextMenuForChild(View p0, float p1, float p2);
    default void onDescendantInvalidated(View p0, View p1){}
    int getLayoutDirection();
    int getTextAlignment();
    int getTextDirection();
    void bringChildToFront(View p0);
    void childDrawableStateChanged(View p0);
    void childHasTransientStateChanged(View p0, boolean p1);
    void clearChildFocus(View p0);
    void createContextMenu(ContextMenu p0);
    void focusableViewAvailable(View p0);
    void invalidateChild(View p0, Rect p1);
    void notifySubtreeAccessibilityStateChanged(View p0, View p1, int p2);
    void onNestedPreScroll(View p0, int p1, int p2, int[] p3);
    void onNestedScroll(View p0, int p1, int p2, int p3, int p4);
    void onNestedScrollAccepted(View p0, View p1, int p2);
    void onStopNestedScroll(View p0);
    void recomputeViewAttributes(View p0);
    void requestChildFocus(View p0, View p1);
    void requestDisallowInterceptTouchEvent(boolean p0);
    void requestFitSystemWindows();
    void requestLayout();
    void requestTransparentRegion(View p0);
}
