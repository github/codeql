// Generated automatically from android.widget.LinearLayout for testing purposes

package android.widget;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.view.ViewGroup;

public class LinearLayout extends ViewGroup
{
    protected LinearLayout() {}
    protected LinearLayout.LayoutParams generateDefaultLayoutParams(){ return null; }
    protected LinearLayout.LayoutParams generateLayoutParams(ViewGroup.LayoutParams p0){ return null; }
    protected boolean checkLayoutParams(ViewGroup.LayoutParams p0){ return false; }
    protected void onDraw(Canvas p0){}
    protected void onLayout(boolean p0, int p1, int p2, int p3, int p4){}
    protected void onMeasure(int p0, int p1){}
    public CharSequence getAccessibilityClassName(){ return null; }
    public Drawable getDividerDrawable(){ return null; }
    public LinearLayout(Context p0){}
    public LinearLayout(Context p0, AttributeSet p1){}
    public LinearLayout(Context p0, AttributeSet p1, int p2){}
    public LinearLayout(Context p0, AttributeSet p1, int p2, int p3){}
    public LinearLayout.LayoutParams generateLayoutParams(AttributeSet p0){ return null; }
    public boolean isBaselineAligned(){ return false; }
    public boolean isMeasureWithLargestChildEnabled(){ return false; }
    public boolean shouldDelayChildPressedState(){ return false; }
    public float getWeightSum(){ return 0; }
    public int getBaseline(){ return 0; }
    public int getBaselineAlignedChildIndex(){ return 0; }
    public int getDividerPadding(){ return 0; }
    public int getGravity(){ return 0; }
    public int getOrientation(){ return 0; }
    public int getShowDividers(){ return 0; }
    public static int HORIZONTAL = 0;
    public static int SHOW_DIVIDER_BEGINNING = 0;
    public static int SHOW_DIVIDER_END = 0;
    public static int SHOW_DIVIDER_MIDDLE = 0;
    public static int SHOW_DIVIDER_NONE = 0;
    public static int VERTICAL = 0;
    public void onRtlPropertiesChanged(int p0){}
    public void setBaselineAligned(boolean p0){}
    public void setBaselineAlignedChildIndex(int p0){}
    public void setDividerDrawable(Drawable p0){}
    public void setDividerPadding(int p0){}
    public void setGravity(int p0){}
    public void setHorizontalGravity(int p0){}
    public void setMeasureWithLargestChildEnabled(boolean p0){}
    public void setOrientation(int p0){}
    public void setShowDividers(int p0){}
    public void setVerticalGravity(int p0){}
    public void setWeightSum(float p0){}
    static public class LayoutParams extends ViewGroup.MarginLayoutParams
    {
        protected LayoutParams() {}
        public LayoutParams(Context p0, AttributeSet p1){}
        public LayoutParams(LinearLayout.LayoutParams p0){}
        public LayoutParams(ViewGroup.LayoutParams p0){}
        public LayoutParams(ViewGroup.MarginLayoutParams p0){}
        public LayoutParams(int p0, int p1){}
        public LayoutParams(int p0, int p1, float p2){}
        public String debug(String p0){ return null; }
        public float weight = 0;
        public int gravity = 0;
    }
}
