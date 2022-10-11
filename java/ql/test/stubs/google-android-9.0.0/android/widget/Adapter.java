// Generated automatically from android.widget.Adapter for testing purposes

package android.widget;

import android.database.DataSetObserver;
import android.view.View;
import android.view.ViewGroup;

public interface Adapter
{
    Object getItem(int p0);
    View getView(int p0, View p1, ViewGroup p2);
    boolean hasStableIds();
    boolean isEmpty();
    default CharSequence[] getAutofillOptions(){ return null; }
    int getCount();
    int getItemViewType(int p0);
    int getViewTypeCount();
    long getItemId(int p0);
    static int IGNORE_ITEM_VIEW_TYPE = 0;
    static int NO_SELECTION = 0;
    void registerDataSetObserver(DataSetObserver p0);
    void unregisterDataSetObserver(DataSetObserver p0);
}
