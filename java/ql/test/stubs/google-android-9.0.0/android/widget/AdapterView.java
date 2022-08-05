// Generated automatically from android.widget.AdapterView for testing purposes

package android.widget;

import android.content.Context;
import android.os.Parcelable;
import android.util.AttributeSet;
import android.util.SparseArray;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewStructure;
import android.widget.Adapter;

abstract public class AdapterView<T extends Adapter> extends ViewGroup
{
    protected AdapterView() {}
    protected boolean canAnimate(){ return false; }
    protected void dispatchRestoreInstanceState(SparseArray<Parcelable> p0){}
    protected void dispatchSaveInstanceState(SparseArray<Parcelable> p0){}
    protected void onDetachedFromWindow(){}
    protected void onLayout(boolean p0, int p1, int p2, int p3, int p4){}
    public AdapterView(Context p0){}
    public AdapterView(Context p0, AttributeSet p1){}
    public AdapterView(Context p0, AttributeSet p1, int p2){}
    public AdapterView(Context p0, AttributeSet p1, int p2, int p3){}
    public CharSequence getAccessibilityClassName(){ return null; }
    public Object getItemAtPosition(int p0){ return null; }
    public Object getSelectedItem(){ return null; }
    public View getEmptyView(){ return null; }
    public abstract T getAdapter();
    public abstract View getSelectedView();
    public abstract void setAdapter(T p0);
    public abstract void setSelection(int p0);
    public boolean performItemClick(View p0, int p1, long p2){ return false; }
    public final AdapterView.OnItemClickListener getOnItemClickListener(){ return null; }
    public final AdapterView.OnItemLongClickListener getOnItemLongClickListener(){ return null; }
    public final AdapterView.OnItemSelectedListener getOnItemSelectedListener(){ return null; }
    public int getCount(){ return 0; }
    public int getFirstVisiblePosition(){ return 0; }
    public int getLastVisiblePosition(){ return 0; }
    public int getPositionForView(View p0){ return 0; }
    public int getSelectedItemPosition(){ return 0; }
    public long getItemIdAtPosition(int p0){ return 0; }
    public long getSelectedItemId(){ return 0; }
    public static int INVALID_POSITION = 0;
    public static int ITEM_VIEW_TYPE_HEADER_OR_FOOTER = 0;
    public static int ITEM_VIEW_TYPE_IGNORE = 0;
    public static long INVALID_ROW_ID = 0;
    public void addView(View p0){}
    public void addView(View p0, ViewGroup.LayoutParams p1){}
    public void addView(View p0, int p1){}
    public void addView(View p0, int p1, ViewGroup.LayoutParams p2){}
    public void onProvideAutofillStructure(ViewStructure p0, int p1){}
    public void removeAllViews(){}
    public void removeView(View p0){}
    public void removeViewAt(int p0){}
    public void setEmptyView(View p0){}
    public void setFocusable(int p0){}
    public void setFocusableInTouchMode(boolean p0){}
    public void setOnClickListener(View.OnClickListener p0){}
    public void setOnItemClickListener(AdapterView.OnItemClickListener p0){}
    public void setOnItemLongClickListener(AdapterView.OnItemLongClickListener p0){}
    public void setOnItemSelectedListener(AdapterView.OnItemSelectedListener p0){}
    static public interface OnItemClickListener
    {
        void onItemClick(AdapterView<? extends Object> p0, View p1, int p2, long p3);
    }
    static public interface OnItemLongClickListener
    {
        boolean onItemLongClick(AdapterView<? extends Object> p0, View p1, int p2, long p3);
    }
    static public interface OnItemSelectedListener
    {
        void onItemSelected(AdapterView<? extends Object> p0, View p1, int p2, long p3);
        void onNothingSelected(AdapterView<? extends Object> p0);
    }
}
