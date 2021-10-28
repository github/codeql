// Generated automatically from android.database.ContentObserver for testing purposes

package android.database;

import android.net.Uri;
import android.os.Handler;

abstract public class ContentObserver
{
    protected ContentObserver() {}
    public ContentObserver(Handler p0){}
    public boolean deliverSelfNotifications(){ return false; }
    public final void dispatchChange(boolean p0){}
    public final void dispatchChange(boolean p0, Uri p1){}
    public void onChange(boolean p0){}
    public void onChange(boolean p0, Uri p1){}
}
