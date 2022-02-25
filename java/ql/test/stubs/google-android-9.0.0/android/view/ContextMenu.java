// Generated automatically from android.view.ContextMenu for testing purposes

package android.view;

import android.graphics.drawable.Drawable;
import android.view.Menu;
import android.view.View;

public interface ContextMenu extends Menu
{
    ContextMenu setHeaderIcon(Drawable p0);
    ContextMenu setHeaderIcon(int p0);
    ContextMenu setHeaderTitle(CharSequence p0);
    ContextMenu setHeaderTitle(int p0);
    ContextMenu setHeaderView(View p0);
    static public interface ContextMenuInfo
    {
    }
    void clearHeader();
}
