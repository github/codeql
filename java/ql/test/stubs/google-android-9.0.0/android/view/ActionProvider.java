// Generated automatically from android.view.ActionProvider for testing purposes

package android.view;

import android.content.Context;
import android.view.MenuItem;
import android.view.SubMenu;
import android.view.View;

abstract public class ActionProvider
{
    protected ActionProvider() {}
    public ActionProvider(Context p0){}
    public View onCreateActionView(MenuItem p0){ return null; }
    public abstract View onCreateActionView();
    public boolean hasSubMenu(){ return false; }
    public boolean isVisible(){ return false; }
    public boolean onPerformDefaultAction(){ return false; }
    public boolean overridesItemVisibility(){ return false; }
    public void onPrepareSubMenu(SubMenu p0){}
    public void refreshVisibility(){}
    public void setVisibilityListener(ActionProvider.VisibilityListener p0){}
    static public interface VisibilityListener
    {
        void onActionProviderVisibilityChanged(boolean p0);
    }
}
