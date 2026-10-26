// Generated automatically from android.view.Menu for testing purposes

package android.view;

import android.content.ComponentName;
import android.content.Intent;
import android.view.KeyEvent;
import android.view.MenuItem;
import android.view.SubMenu;

public interface Menu
{
    MenuItem add(CharSequence p0);
    MenuItem add(int p0);
    MenuItem add(int p0, int p1, int p2, CharSequence p3);
    MenuItem add(int p0, int p1, int p2, int p3);
    MenuItem findItem(int p0);
    MenuItem getItem(int p0);
    SubMenu addSubMenu(CharSequence p0);
    SubMenu addSubMenu(int p0);
    SubMenu addSubMenu(int p0, int p1, int p2, CharSequence p3);
    SubMenu addSubMenu(int p0, int p1, int p2, int p3);
    boolean hasVisibleItems();
    boolean isShortcutKey(int p0, KeyEvent p1);
    boolean performIdentifierAction(int p0, int p1);
    boolean performShortcut(int p0, KeyEvent p1, int p2);
    default void setGroupDividerEnabled(boolean p0){}
    int addIntentOptions(int p0, int p1, int p2, ComponentName p3, Intent[] p4, Intent p5, int p6, MenuItem[] p7);
    int size();
    static int CATEGORY_ALTERNATIVE = 0;
    static int CATEGORY_CONTAINER = 0;
    static int CATEGORY_SECONDARY = 0;
    static int CATEGORY_SYSTEM = 0;
    static int FIRST = 0;
    static int FLAG_ALWAYS_PERFORM_CLOSE = 0;
    static int FLAG_APPEND_TO_GROUP = 0;
    static int FLAG_PERFORM_NO_CLOSE = 0;
    static int NONE = 0;
    static int SUPPORTED_MODIFIERS_MASK = 0;
    void clear();
    void close();
    void removeGroup(int p0);
    void removeItem(int p0);
    void setGroupCheckable(int p0, boolean p1, boolean p2);
    void setGroupEnabled(int p0, boolean p1);
    void setGroupVisible(int p0, boolean p1);
    void setQwertyMode(boolean p0);
}
