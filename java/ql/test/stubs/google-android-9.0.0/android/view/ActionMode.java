// Generated automatically from android.view.ActionMode for testing purposes

package android.view;

import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;

abstract public class ActionMode
{
    public ActionMode(){}
    public Object getTag(){ return null; }
    public abstract CharSequence getSubtitle();
    public abstract CharSequence getTitle();
    public abstract Menu getMenu();
    public abstract MenuInflater getMenuInflater();
    public abstract View getCustomView();
    public abstract void finish();
    public abstract void invalidate();
    public abstract void setCustomView(View p0);
    public abstract void setSubtitle(CharSequence p0);
    public abstract void setSubtitle(int p0);
    public abstract void setTitle(CharSequence p0);
    public abstract void setTitle(int p0);
    public boolean getTitleOptionalHint(){ return false; }
    public boolean isTitleOptional(){ return false; }
    public int getType(){ return 0; }
    public static int DEFAULT_HIDE_DURATION = 0;
    public static int TYPE_FLOATING = 0;
    public static int TYPE_PRIMARY = 0;
    public void hide(long p0){}
    public void invalidateContentRect(){}
    public void onWindowFocusChanged(boolean p0){}
    public void setTag(Object p0){}
    public void setTitleOptionalHint(boolean p0){}
    public void setType(int p0){}
    static public interface Callback
    {
        boolean onActionItemClicked(ActionMode p0, MenuItem p1);
        boolean onCreateActionMode(ActionMode p0, Menu p1);
        boolean onPrepareActionMode(ActionMode p0, Menu p1);
        void onDestroyActionMode(ActionMode p0);
    }
}
