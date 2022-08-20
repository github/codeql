// Generated automatically from android.view.SubMenu for testing purposes

package android.view;

import android.graphics.drawable.Drawable;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;

public interface SubMenu extends Menu
{
    MenuItem getItem();
    SubMenu setHeaderIcon(Drawable p0);
    SubMenu setHeaderIcon(int p0);
    SubMenu setHeaderTitle(CharSequence p0);
    SubMenu setHeaderTitle(int p0);
    SubMenu setHeaderView(View p0);
    SubMenu setIcon(Drawable p0);
    SubMenu setIcon(int p0);
    void clearHeader();
}
