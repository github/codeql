// Generated automatically from android.webkit.WebHistoryItem for testing purposes

package android.webkit;

import android.graphics.Bitmap;

abstract public class WebHistoryItem implements Cloneable
{
    protected abstract WebHistoryItem clone();
    public WebHistoryItem(){}
    public abstract Bitmap getFavicon();
    public abstract String getOriginalUrl();
    public abstract String getTitle();
    public abstract String getUrl();
}
