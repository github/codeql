// Generated automatically from android.webkit.WebBackForwardList for testing purposes

package android.webkit;

import android.webkit.WebHistoryItem;
import java.io.Serializable;

abstract public class WebBackForwardList implements Cloneable, Serializable
{
    protected abstract WebBackForwardList clone();
    public WebBackForwardList(){}
    public abstract WebHistoryItem getCurrentItem();
    public abstract WebHistoryItem getItemAtIndex(int p0);
    public abstract int getCurrentIndex();
    public abstract int getSize();
}
