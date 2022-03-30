// Generated automatically from android.view.MenuItem for testing purposes

package android.view;

import android.content.Intent;
import android.content.res.ColorStateList;
import android.graphics.BlendMode;
import android.graphics.PorterDuff;
import android.graphics.drawable.Drawable;
import android.view.ActionProvider;
import android.view.ContextMenu;
import android.view.SubMenu;
import android.view.View;

public interface MenuItem
{
    ActionProvider getActionProvider();
    CharSequence getTitle();
    CharSequence getTitleCondensed();
    ContextMenu.ContextMenuInfo getMenuInfo();
    Drawable getIcon();
    Intent getIntent();
    MenuItem setActionProvider(ActionProvider p0);
    MenuItem setActionView(View p0);
    MenuItem setActionView(int p0);
    MenuItem setAlphabeticShortcut(char p0);
    MenuItem setCheckable(boolean p0);
    MenuItem setChecked(boolean p0);
    MenuItem setEnabled(boolean p0);
    MenuItem setIcon(Drawable p0);
    MenuItem setIcon(int p0);
    MenuItem setIntent(Intent p0);
    MenuItem setNumericShortcut(char p0);
    MenuItem setOnActionExpandListener(MenuItem.OnActionExpandListener p0);
    MenuItem setOnMenuItemClickListener(MenuItem.OnMenuItemClickListener p0);
    MenuItem setShortcut(char p0, char p1);
    MenuItem setShowAsActionFlags(int p0);
    MenuItem setTitle(CharSequence p0);
    MenuItem setTitle(int p0);
    MenuItem setTitleCondensed(CharSequence p0);
    MenuItem setVisible(boolean p0);
    SubMenu getSubMenu();
    View getActionView();
    boolean collapseActionView();
    boolean expandActionView();
    boolean hasSubMenu();
    boolean isActionViewExpanded();
    boolean isCheckable();
    boolean isChecked();
    boolean isEnabled();
    boolean isVisible();
    char getAlphabeticShortcut();
    char getNumericShortcut();
    default BlendMode getIconTintBlendMode(){ return null; }
    default CharSequence getContentDescription(){ return null; }
    default CharSequence getTooltipText(){ return null; }
    default ColorStateList getIconTintList(){ return null; }
    default MenuItem setAlphabeticShortcut(char p0, int p1){ return null; }
    default MenuItem setContentDescription(CharSequence p0){ return null; }
    default MenuItem setIconTintBlendMode(BlendMode p0){ return null; }
    default MenuItem setIconTintList(ColorStateList p0){ return null; }
    default MenuItem setIconTintMode(PorterDuff.Mode p0){ return null; }
    default MenuItem setNumericShortcut(char p0, int p1){ return null; }
    default MenuItem setShortcut(char p0, char p1, int p2, int p3){ return null; }
    default MenuItem setTooltipText(CharSequence p0){ return null; }
    default PorterDuff.Mode getIconTintMode(){ return null; }
    default int getAlphabeticModifiers(){ return 0; }
    default int getNumericModifiers(){ return 0; }
    int getGroupId();
    int getItemId();
    int getOrder();
    static int SHOW_AS_ACTION_ALWAYS = 0;
    static int SHOW_AS_ACTION_COLLAPSE_ACTION_VIEW = 0;
    static int SHOW_AS_ACTION_IF_ROOM = 0;
    static int SHOW_AS_ACTION_NEVER = 0;
    static int SHOW_AS_ACTION_WITH_TEXT = 0;
    static public interface OnActionExpandListener
    {
        boolean onMenuItemActionCollapse(MenuItem p0);
        boolean onMenuItemActionExpand(MenuItem p0);
    }
    static public interface OnMenuItemClickListener
    {
        boolean onMenuItemClick(MenuItem p0);
    }
    void setShowAsAction(int p0);
}
