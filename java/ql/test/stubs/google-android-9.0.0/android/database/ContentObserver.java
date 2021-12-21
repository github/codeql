// Generated automatically from android.database.ContentObserver for testing purposes

package android.database;

import android.net.Uri;
import android.os.Handler;
import java.util.Collection;

abstract public class ContentObserver
{
    protected ContentObserver() {}
    public ContentObserver(Handler p0){}
    public boolean deliverSelfNotifications(){ return false; }
    public final void dispatchChange(boolean p0){}
    public final void dispatchChange(boolean p0, Collection<Uri> p1, int p2){}
    public final void dispatchChange(boolean p0, Uri p1){}
    public final void dispatchChange(boolean p0, Uri p1, int p2){}
    public void onChange(boolean p0){}
    public void onChange(boolean p0, Collection<Uri> p1, int p2){}
    public void onChange(boolean p0, Uri p1){}
    public void onChange(boolean p0, Uri p1, int p2){}
}
