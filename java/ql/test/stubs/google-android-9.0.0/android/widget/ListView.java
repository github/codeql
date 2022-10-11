// Generated automatically from android.widget.ListView for testing purposes

package android.widget;

import android.content.Context;
import android.content.Intent;
import android.graphics.Canvas;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.view.KeyEvent;
import android.view.View;
import android.view.accessibility.AccessibilityNodeInfo;
import android.widget.AbsListView;
import android.widget.ListAdapter;

public class ListView extends AbsListView
{
    protected ListView() {}
    protected boolean canAnimate(){ return false; }
    protected boolean drawChild(Canvas p0, View p1, long p2){ return false; }
    protected void dispatchDraw(Canvas p0){}
    protected void layoutChildren(){}
    protected void onDetachedFromWindow(){}
    protected void onFinishInflate(){}
    protected void onFocusChanged(boolean p0, int p1, Rect p2){}
    protected void onMeasure(int p0, int p1){}
    protected void onSizeChanged(int p0, int p1, int p2, int p3){}
    public CharSequence getAccessibilityClassName(){ return null; }
    public Drawable getDivider(){ return null; }
    public Drawable getOverscrollFooter(){ return null; }
    public Drawable getOverscrollHeader(){ return null; }
    public ListAdapter getAdapter(){ return null; }
    public ListView(Context p0){}
    public ListView(Context p0, AttributeSet p1){}
    public ListView(Context p0, AttributeSet p1, int p2){}
    public ListView(Context p0, AttributeSet p1, int p2, int p3){}
    public boolean areFooterDividersEnabled(){ return false; }
    public boolean areHeaderDividersEnabled(){ return false; }
    public boolean dispatchKeyEvent(KeyEvent p0){ return false; }
    public boolean getItemsCanFocus(){ return false; }
    public boolean isOpaque(){ return false; }
    public boolean onKeyDown(int p0, KeyEvent p1){ return false; }
    public boolean onKeyMultiple(int p0, int p1, KeyEvent p2){ return false; }
    public boolean onKeyUp(int p0, KeyEvent p1){ return false; }
    public boolean removeFooterView(View p0){ return false; }
    public boolean removeHeaderView(View p0){ return false; }
    public boolean requestChildRectangleOnScreen(View p0, Rect p1, boolean p2){ return false; }
    public int getDividerHeight(){ return 0; }
    public int getFooterViewsCount(){ return 0; }
    public int getHeaderViewsCount(){ return 0; }
    public int getMaxScrollAmount(){ return 0; }
    public long[] getCheckItemIds(){ return null; }
    public void addFooterView(View p0){}
    public void addFooterView(View p0, Object p1, boolean p2){}
    public void addHeaderView(View p0){}
    public void addHeaderView(View p0, Object p1, boolean p2){}
    public void onInitializeAccessibilityNodeInfoForItem(View p0, int p1, AccessibilityNodeInfo p2){}
    public void setAdapter(ListAdapter p0){}
    public void setCacheColorHint(int p0){}
    public void setDivider(Drawable p0){}
    public void setDividerHeight(int p0){}
    public void setFooterDividersEnabled(boolean p0){}
    public void setHeaderDividersEnabled(boolean p0){}
    public void setItemsCanFocus(boolean p0){}
    public void setOverscrollFooter(Drawable p0){}
    public void setOverscrollHeader(Drawable p0){}
    public void setRemoteViewsAdapter(Intent p0){}
    public void setSelection(int p0){}
    public void setSelectionAfterHeaderView(){}
    public void smoothScrollByOffset(int p0){}
    public void smoothScrollToPosition(int p0){}
}
