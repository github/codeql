// Generated automatically from android.widget.AbsListView for testing purposes

package android.widget;

import android.content.Context;
import android.content.Intent;
import android.graphics.Canvas;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.os.Parcelable;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.AttributeSet;
import android.util.SparseBooleanArray;
import android.view.ActionMode;
import android.view.ContextMenu;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.PointerIcon;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.view.accessibility.AccessibilityNodeInfo;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputConnection;
import android.widget.Adapter;
import android.widget.AdapterView;
import android.widget.Filter;
import android.widget.ListAdapter;
import java.util.ArrayList;
import java.util.List;

abstract public class AbsListView extends AdapterView<ListAdapter> implements Filter.FilterListener, TextWatcher, ViewTreeObserver.OnGlobalLayoutListener, ViewTreeObserver.OnTouchModeChangeListener
{
    protected AbsListView() {}
    protected ContextMenu.ContextMenuInfo getContextMenuInfo(){ return null; }
    protected ViewGroup.LayoutParams generateDefaultLayoutParams(){ return null; }
    protected ViewGroup.LayoutParams generateLayoutParams(ViewGroup.LayoutParams p0){ return null; }
    protected boolean checkLayoutParams(ViewGroup.LayoutParams p0){ return false; }
    protected boolean isInFilterMode(){ return false; }
    protected boolean isPaddingOffsetRequired(){ return false; }
    protected float getBottomFadingEdgeStrength(){ return 0; }
    protected float getTopFadingEdgeStrength(){ return 0; }
    protected int computeVerticalScrollExtent(){ return 0; }
    protected int computeVerticalScrollOffset(){ return 0; }
    protected int computeVerticalScrollRange(){ return 0; }
    protected int getBottomPaddingOffset(){ return 0; }
    protected int getLeftPaddingOffset(){ return 0; }
    protected int getRightPaddingOffset(){ return 0; }
    protected int getTopPaddingOffset(){ return 0; }
    protected void dispatchDraw(Canvas p0){}
    protected void dispatchSetPressed(boolean p0){}
    protected void drawableStateChanged(){}
    protected void handleDataChanged(){}
    protected void layoutChildren(){}
    protected void onAttachedToWindow(){}
    protected void onDetachedFromWindow(){}
    protected void onDisplayHint(int p0){}
    protected void onFocusChanged(boolean p0, int p1, Rect p2){}
    protected void onLayout(boolean p0, int p1, int p2, int p3, int p4){}
    protected void onMeasure(int p0, int p1){}
    protected void onOverScrolled(int p0, int p1, boolean p2, boolean p3){}
    protected void onSizeChanged(int p0, int p1, int p2, int p3){}
    public AbsListView(Context p0){}
    public AbsListView(Context p0, AttributeSet p1){}
    public AbsListView(Context p0, AttributeSet p1, int p2){}
    public AbsListView(Context p0, AttributeSet p1, int p2, int p3){}
    public AbsListView.LayoutParams generateLayoutParams(AttributeSet p0){ return null; }
    public CharSequence getAccessibilityClassName(){ return null; }
    public CharSequence getTextFilter(){ return null; }
    public Drawable getSelector(){ return null; }
    public InputConnection onCreateInputConnection(EditorInfo p0){ return null; }
    public Parcelable onSaveInstanceState(){ return null; }
    public PointerIcon onResolvePointerIcon(MotionEvent p0, int p1){ return null; }
    public SparseBooleanArray getCheckedItemPositions(){ return null; }
    public View getSelectedView(){ return null; }
    public boolean canScrollList(int p0){ return false; }
    public boolean checkInputConnectionProxy(View p0){ return false; }
    public boolean hasTextFilter(){ return false; }
    public boolean isDrawSelectorOnTop(){ return false; }
    public boolean isFastScrollAlwaysVisible(){ return false; }
    public boolean isFastScrollEnabled(){ return false; }
    public boolean isItemChecked(int p0){ return false; }
    public boolean isScrollingCacheEnabled(){ return false; }
    public boolean isSmoothScrollbarEnabled(){ return false; }
    public boolean isStackFromBottom(){ return false; }
    public boolean isTextFilterEnabled(){ return false; }
    public boolean onGenericMotionEvent(MotionEvent p0){ return false; }
    public boolean onInterceptHoverEvent(MotionEvent p0){ return false; }
    public boolean onInterceptTouchEvent(MotionEvent p0){ return false; }
    public boolean onKeyDown(int p0, KeyEvent p1){ return false; }
    public boolean onKeyUp(int p0, KeyEvent p1){ return false; }
    public boolean onNestedFling(View p0, float p1, float p2, boolean p3){ return false; }
    public boolean onRemoteAdapterConnected(){ return false; }
    public boolean onStartNestedScroll(View p0, View p1, int p2){ return false; }
    public boolean onTouchEvent(MotionEvent p0){ return false; }
    public boolean performItemClick(View p0, int p1, long p2){ return false; }
    public boolean showContextMenu(){ return false; }
    public boolean showContextMenu(float p0, float p1){ return false; }
    public boolean showContextMenuForChild(View p0){ return false; }
    public boolean showContextMenuForChild(View p0, float p1, float p2){ return false; }
    public boolean verifyDrawable(Drawable p0){ return false; }
    public int getBottomEdgeEffectColor(){ return 0; }
    public int getCacheColorHint(){ return 0; }
    public int getCheckedItemCount(){ return 0; }
    public int getCheckedItemPosition(){ return 0; }
    public int getChoiceMode(){ return 0; }
    public int getListPaddingBottom(){ return 0; }
    public int getListPaddingLeft(){ return 0; }
    public int getListPaddingRight(){ return 0; }
    public int getListPaddingTop(){ return 0; }
    public int getSolidColor(){ return 0; }
    public int getTopEdgeEffectColor(){ return 0; }
    public int getTranscriptMode(){ return 0; }
    public int getVerticalScrollbarWidth(){ return 0; }
    public int pointToPosition(int p0, int p1){ return 0; }
    public long pointToRowId(int p0, int p1){ return 0; }
    public long[] getCheckedItemIds(){ return null; }
    public static int CHOICE_MODE_MULTIPLE = 0;
    public static int CHOICE_MODE_MULTIPLE_MODAL = 0;
    public static int CHOICE_MODE_NONE = 0;
    public static int CHOICE_MODE_SINGLE = 0;
    public static int TRANSCRIPT_MODE_ALWAYS_SCROLL = 0;
    public static int TRANSCRIPT_MODE_DISABLED = 0;
    public static int TRANSCRIPT_MODE_NORMAL = 0;
    public void addTouchables(ArrayList<View> p0){}
    public void afterTextChanged(Editable p0){}
    public void beforeTextChanged(CharSequence p0, int p1, int p2, int p3){}
    public void clearChoices(){}
    public void clearTextFilter(){}
    public void deferNotifyDataSetChanged(){}
    public void dispatchDrawableHotspotChanged(float p0, float p1){}
    public void draw(Canvas p0){}
    public void fling(int p0){}
    public void getFocusedRect(Rect p0){}
    public void invalidateViews(){}
    public void jumpDrawablesToCurrentState(){}
    public void onCancelPendingInputEvents(){}
    public void onFilterComplete(int p0){}
    public void onGlobalLayout(){}
    public void onInitializeAccessibilityNodeInfoForItem(View p0, int p1, AccessibilityNodeInfo p2){}
    public void onNestedScroll(View p0, int p1, int p2, int p3, int p4){}
    public void onNestedScrollAccepted(View p0, View p1, int p2){}
    public void onRemoteAdapterDisconnected(){}
    public void onRestoreInstanceState(Parcelable p0){}
    public void onRtlPropertiesChanged(int p0){}
    public void onTextChanged(CharSequence p0, int p1, int p2, int p3){}
    public void onTouchModeChanged(boolean p0){}
    public void onWindowFocusChanged(boolean p0){}
    public void reclaimViews(List<View> p0){}
    public void requestDisallowInterceptTouchEvent(boolean p0){}
    public void requestLayout(){}
    public void scrollListBy(int p0){}
    public void setAdapter(ListAdapter p0){}
    public void setBottomEdgeEffectColor(int p0){}
    public void setCacheColorHint(int p0){}
    public void setChoiceMode(int p0){}
    public void setDrawSelectorOnTop(boolean p0){}
    public void setEdgeEffectColor(int p0){}
    public void setFastScrollAlwaysVisible(boolean p0){}
    public void setFastScrollEnabled(boolean p0){}
    public void setFastScrollStyle(int p0){}
    public void setFilterText(String p0){}
    public void setFriction(float p0){}
    public void setItemChecked(int p0, boolean p1){}
    public void setMultiChoiceModeListener(AbsListView.MultiChoiceModeListener p0){}
    public void setOnScrollListener(AbsListView.OnScrollListener p0){}
    public void setRecyclerListener(AbsListView.RecyclerListener p0){}
    public void setRemoteViewsAdapter(Intent p0){}
    public void setScrollBarStyle(int p0){}
    public void setScrollIndicators(View p0, View p1){}
    public void setScrollingCacheEnabled(boolean p0){}
    public void setSelectionFromTop(int p0, int p1){}
    public void setSelector(Drawable p0){}
    public void setSelector(int p0){}
    public void setSmoothScrollbarEnabled(boolean p0){}
    public void setStackFromBottom(boolean p0){}
    public void setTextFilterEnabled(boolean p0){}
    public void setTopEdgeEffectColor(int p0){}
    public void setTranscriptMode(int p0){}
    public void setVelocityScale(float p0){}
    public void setVerticalScrollbarPosition(int p0){}
    public void smoothScrollBy(int p0, int p1){}
    public void smoothScrollToPosition(int p0){}
    public void smoothScrollToPosition(int p0, int p1){}
    public void smoothScrollToPositionFromTop(int p0, int p1){}
    public void smoothScrollToPositionFromTop(int p0, int p1, int p2){}
    static public class LayoutParams extends ViewGroup.LayoutParams
    {
        protected LayoutParams() {}
        public LayoutParams(Context p0, AttributeSet p1){}
        public LayoutParams(ViewGroup.LayoutParams p0){}
        public LayoutParams(int p0, int p1){}
        public LayoutParams(int p0, int p1, int p2){}
    }
    static public interface MultiChoiceModeListener extends ActionMode.Callback
    {
        void onItemCheckedStateChanged(ActionMode p0, int p1, long p2, boolean p3);
    }
    static public interface OnScrollListener
    {
        static int SCROLL_STATE_FLING = 0;
        static int SCROLL_STATE_IDLE = 0;
        static int SCROLL_STATE_TOUCH_SCROLL = 0;
        void onScroll(AbsListView p0, int p1, int p2, int p3);
        void onScrollStateChanged(AbsListView p0, int p1);
    }
    static public interface RecyclerListener
    {
        void onMovedToScrapHeap(View p0);
    }
}
