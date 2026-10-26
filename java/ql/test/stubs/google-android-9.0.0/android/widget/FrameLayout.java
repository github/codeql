// Generated automatically from android.widget.FrameLayout for testing purposes

package android.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.view.ViewGroup;

public class FrameLayout extends ViewGroup
{
    protected FrameLayout() {}
    protected FrameLayout.LayoutParams generateDefaultLayoutParams(){ return null; }
    protected ViewGroup.LayoutParams generateLayoutParams(ViewGroup.LayoutParams p0){ return null; }
    protected boolean checkLayoutParams(ViewGroup.LayoutParams p0){ return false; }
    protected void onLayout(boolean p0, int p1, int p2, int p3, int p4){}
    protected void onMeasure(int p0, int p1){}
    public CharSequence getAccessibilityClassName(){ return null; }
    public FrameLayout(Context p0){}
    public FrameLayout(Context p0, AttributeSet p1){}
    public FrameLayout(Context p0, AttributeSet p1, int p2){}
    public FrameLayout(Context p0, AttributeSet p1, int p2, int p3){}
    public FrameLayout.LayoutParams generateLayoutParams(AttributeSet p0){ return null; }
    public boolean getConsiderGoneChildrenWhenMeasuring(){ return false; }
    public boolean getMeasureAllChildren(){ return false; }
    public boolean shouldDelayChildPressedState(){ return false; }
    public void setForegroundGravity(int p0){}
    public void setMeasureAllChildren(boolean p0){}
    static public class LayoutParams extends ViewGroup.MarginLayoutParams
    {
        protected LayoutParams() {}
        public LayoutParams(Context p0, AttributeSet p1){}
        public LayoutParams(FrameLayout.LayoutParams p0){}
        public LayoutParams(ViewGroup.LayoutParams p0){}
        public LayoutParams(ViewGroup.MarginLayoutParams p0){}
        public LayoutParams(int p0, int p1){}
        public LayoutParams(int p0, int p1, int p2){}
        public int gravity = 0;
        public static int UNSPECIFIED_GRAVITY = 0;
    }
}
