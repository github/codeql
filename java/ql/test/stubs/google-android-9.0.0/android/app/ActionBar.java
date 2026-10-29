// Generated automatically from android.app.ActionBar for testing purposes

package android.app;

import android.app.FragmentTransaction;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.widget.SpinnerAdapter;

abstract public class ActionBar
{
    abstract static public class Tab
    {
        public Tab(){}
        public abstract ActionBar.Tab setContentDescription(CharSequence p0);
        public abstract ActionBar.Tab setContentDescription(int p0);
        public abstract ActionBar.Tab setCustomView(View p0);
        public abstract ActionBar.Tab setCustomView(int p0);
        public abstract ActionBar.Tab setIcon(Drawable p0);
        public abstract ActionBar.Tab setIcon(int p0);
        public abstract ActionBar.Tab setTabListener(ActionBar.TabListener p0);
        public abstract ActionBar.Tab setTag(Object p0);
        public abstract ActionBar.Tab setText(CharSequence p0);
        public abstract ActionBar.Tab setText(int p0);
        public abstract CharSequence getContentDescription();
        public abstract CharSequence getText();
        public abstract Drawable getIcon();
        public abstract Object getTag();
        public abstract View getCustomView();
        public abstract int getPosition();
        public abstract void select();
        public static int INVALID_POSITION = 0;
    }
    public ActionBar(){}
    public Context getThemedContext(){ return null; }
    public abstract ActionBar.Tab getSelectedTab();
    public abstract ActionBar.Tab getTabAt(int p0);
    public abstract ActionBar.Tab newTab();
    public abstract CharSequence getSubtitle();
    public abstract CharSequence getTitle();
    public abstract View getCustomView();
    public abstract boolean isShowing();
    public abstract int getDisplayOptions();
    public abstract int getHeight();
    public abstract int getNavigationItemCount();
    public abstract int getNavigationMode();
    public abstract int getSelectedNavigationIndex();
    public abstract int getTabCount();
    public abstract void addOnMenuVisibilityListener(ActionBar.OnMenuVisibilityListener p0);
    public abstract void addTab(ActionBar.Tab p0);
    public abstract void addTab(ActionBar.Tab p0, boolean p1);
    public abstract void addTab(ActionBar.Tab p0, int p1);
    public abstract void addTab(ActionBar.Tab p0, int p1, boolean p2);
    public abstract void hide();
    public abstract void removeAllTabs();
    public abstract void removeOnMenuVisibilityListener(ActionBar.OnMenuVisibilityListener p0);
    public abstract void removeTab(ActionBar.Tab p0);
    public abstract void removeTabAt(int p0);
    public abstract void selectTab(ActionBar.Tab p0);
    public abstract void setBackgroundDrawable(Drawable p0);
    public abstract void setCustomView(View p0);
    public abstract void setCustomView(View p0, ActionBar.LayoutParams p1);
    public abstract void setCustomView(int p0);
    public abstract void setDisplayHomeAsUpEnabled(boolean p0);
    public abstract void setDisplayOptions(int p0);
    public abstract void setDisplayOptions(int p0, int p1);
    public abstract void setDisplayShowCustomEnabled(boolean p0);
    public abstract void setDisplayShowHomeEnabled(boolean p0);
    public abstract void setDisplayShowTitleEnabled(boolean p0);
    public abstract void setDisplayUseLogoEnabled(boolean p0);
    public abstract void setIcon(Drawable p0);
    public abstract void setIcon(int p0);
    public abstract void setListNavigationCallbacks(SpinnerAdapter p0, ActionBar.OnNavigationListener p1);
    public abstract void setLogo(Drawable p0);
    public abstract void setLogo(int p0);
    public abstract void setNavigationMode(int p0);
    public abstract void setSelectedNavigationItem(int p0);
    public abstract void setSubtitle(CharSequence p0);
    public abstract void setSubtitle(int p0);
    public abstract void setTitle(CharSequence p0);
    public abstract void setTitle(int p0);
    public abstract void show();
    public boolean isHideOnContentScrollEnabled(){ return false; }
    public float getElevation(){ return 0; }
    public int getHideOffset(){ return 0; }
    public static int DISPLAY_HOME_AS_UP = 0;
    public static int DISPLAY_SHOW_CUSTOM = 0;
    public static int DISPLAY_SHOW_HOME = 0;
    public static int DISPLAY_SHOW_TITLE = 0;
    public static int DISPLAY_USE_LOGO = 0;
    public static int NAVIGATION_MODE_LIST = 0;
    public static int NAVIGATION_MODE_STANDARD = 0;
    public static int NAVIGATION_MODE_TABS = 0;
    public void setElevation(float p0){}
    public void setHideOffset(int p0){}
    public void setHideOnContentScrollEnabled(boolean p0){}
    public void setHomeActionContentDescription(CharSequence p0){}
    public void setHomeActionContentDescription(int p0){}
    public void setHomeAsUpIndicator(Drawable p0){}
    public void setHomeAsUpIndicator(int p0){}
    public void setHomeButtonEnabled(boolean p0){}
    public void setSplitBackgroundDrawable(Drawable p0){}
    public void setStackedBackgroundDrawable(Drawable p0){}
    static public class LayoutParams extends ViewGroup.MarginLayoutParams
    {
        protected LayoutParams() {}
        public LayoutParams(ActionBar.LayoutParams p0){}
        public LayoutParams(Context p0, AttributeSet p1){}
        public LayoutParams(ViewGroup.LayoutParams p0){}
        public LayoutParams(int p0){}
        public LayoutParams(int p0, int p1){}
        public LayoutParams(int p0, int p1, int p2){}
        public int gravity = 0;
    }
    static public interface OnMenuVisibilityListener
    {
        void onMenuVisibilityChanged(boolean p0);
    }
    static public interface OnNavigationListener
    {
        boolean onNavigationItemSelected(int p0, long p1);
    }
    static public interface TabListener
    {
        void onTabReselected(ActionBar.Tab p0, FragmentTransaction p1);
        void onTabSelected(ActionBar.Tab p0, FragmentTransaction p1);
        void onTabUnselected(ActionBar.Tab p0, FragmentTransaction p1);
    }
}
