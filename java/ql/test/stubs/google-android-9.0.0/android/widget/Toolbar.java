// Generated automatically from android.widget.Toolbar for testing purposes

package android.widget;

import android.app.ActionBar;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.os.Parcelable;
import android.util.AttributeSet;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;

public class Toolbar extends ViewGroup
{
    protected Toolbar() {}
    protected Parcelable onSaveInstanceState(){ return null; }
    protected Toolbar.LayoutParams generateDefaultLayoutParams(){ return null; }
    protected Toolbar.LayoutParams generateLayoutParams(ViewGroup.LayoutParams p0){ return null; }
    protected boolean checkLayoutParams(ViewGroup.LayoutParams p0){ return false; }
    protected void onAttachedToWindow(){}
    protected void onDetachedFromWindow(){}
    protected void onLayout(boolean p0, int p1, int p2, int p3, int p4){}
    protected void onMeasure(int p0, int p1){}
    protected void onRestoreInstanceState(Parcelable p0){}
    public CharSequence getCollapseContentDescription(){ return null; }
    public CharSequence getLogoDescription(){ return null; }
    public CharSequence getNavigationContentDescription(){ return null; }
    public CharSequence getSubtitle(){ return null; }
    public CharSequence getTitle(){ return null; }
    public Drawable getCollapseIcon(){ return null; }
    public Drawable getLogo(){ return null; }
    public Drawable getNavigationIcon(){ return null; }
    public Drawable getOverflowIcon(){ return null; }
    public Menu getMenu(){ return null; }
    public Toolbar(Context p0){}
    public Toolbar(Context p0, AttributeSet p1){}
    public Toolbar(Context p0, AttributeSet p1, int p2){}
    public Toolbar(Context p0, AttributeSet p1, int p2, int p3){}
    public Toolbar.LayoutParams generateLayoutParams(AttributeSet p0){ return null; }
    public boolean hasExpandedActionView(){ return false; }
    public boolean hideOverflowMenu(){ return false; }
    public boolean isOverflowMenuShowing(){ return false; }
    public boolean onTouchEvent(MotionEvent p0){ return false; }
    public boolean showOverflowMenu(){ return false; }
    public int getContentInsetEnd(){ return 0; }
    public int getContentInsetEndWithActions(){ return 0; }
    public int getContentInsetLeft(){ return 0; }
    public int getContentInsetRight(){ return 0; }
    public int getContentInsetStart(){ return 0; }
    public int getContentInsetStartWithNavigation(){ return 0; }
    public int getCurrentContentInsetEnd(){ return 0; }
    public int getCurrentContentInsetLeft(){ return 0; }
    public int getCurrentContentInsetRight(){ return 0; }
    public int getCurrentContentInsetStart(){ return 0; }
    public int getPopupTheme(){ return 0; }
    public int getTitleMarginBottom(){ return 0; }
    public int getTitleMarginEnd(){ return 0; }
    public int getTitleMarginStart(){ return 0; }
    public int getTitleMarginTop(){ return 0; }
    public void collapseActionView(){}
    public void dismissPopupMenus(){}
    public void inflateMenu(int p0){}
    public void onRtlPropertiesChanged(int p0){}
    public void setCollapseContentDescription(CharSequence p0){}
    public void setCollapseContentDescription(int p0){}
    public void setCollapseIcon(Drawable p0){}
    public void setCollapseIcon(int p0){}
    public void setContentInsetEndWithActions(int p0){}
    public void setContentInsetStartWithNavigation(int p0){}
    public void setContentInsetsAbsolute(int p0, int p1){}
    public void setContentInsetsRelative(int p0, int p1){}
    public void setLogo(Drawable p0){}
    public void setLogo(int p0){}
    public void setLogoDescription(CharSequence p0){}
    public void setLogoDescription(int p0){}
    public void setNavigationContentDescription(CharSequence p0){}
    public void setNavigationContentDescription(int p0){}
    public void setNavigationIcon(Drawable p0){}
    public void setNavigationIcon(int p0){}
    public void setNavigationOnClickListener(View.OnClickListener p0){}
    public void setOnMenuItemClickListener(Toolbar.OnMenuItemClickListener p0){}
    public void setOverflowIcon(Drawable p0){}
    public void setPopupTheme(int p0){}
    public void setSubtitle(CharSequence p0){}
    public void setSubtitle(int p0){}
    public void setSubtitleTextAppearance(Context p0, int p1){}
    public void setSubtitleTextColor(int p0){}
    public void setTitle(CharSequence p0){}
    public void setTitle(int p0){}
    public void setTitleMargin(int p0, int p1, int p2, int p3){}
    public void setTitleMarginBottom(int p0){}
    public void setTitleMarginEnd(int p0){}
    public void setTitleMarginStart(int p0){}
    public void setTitleMarginTop(int p0){}
    public void setTitleTextAppearance(Context p0, int p1){}
    public void setTitleTextColor(int p0){}
    static public class LayoutParams extends ActionBar.LayoutParams
    {
        protected LayoutParams() {}
        public LayoutParams(ActionBar.LayoutParams p0){}
        public LayoutParams(Context p0, AttributeSet p1){}
        public LayoutParams(Toolbar.LayoutParams p0){}
        public LayoutParams(ViewGroup.LayoutParams p0){}
        public LayoutParams(ViewGroup.MarginLayoutParams p0){}
        public LayoutParams(int p0){}
        public LayoutParams(int p0, int p1){}
        public LayoutParams(int p0, int p1, int p2){}
    }
    static public interface OnMenuItemClickListener
    {
        boolean onMenuItemClick(MenuItem p0);
    }
}
