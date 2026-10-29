// Generated automatically from android.webkit.GeolocationPermissions for testing purposes

package android.webkit;

import android.webkit.ValueCallback;
import java.util.Set;

public class GeolocationPermissions
{
    public static GeolocationPermissions getInstance(){ return null; }
    public void allow(String p0){}
    public void clear(String p0){}
    public void clearAll(){}
    public void getAllowed(String p0, ValueCallback<Boolean> p1){}
    public void getOrigins(ValueCallback<Set<String>> p0){}
    static public interface Callback
    {
        void invoke(String p0, boolean p1, boolean p2);
    }
}
