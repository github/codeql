// Generated automatically from android.content.ServiceConnection for testing purposes

package android.content;

import android.content.ComponentName;
import android.os.IBinder;

public interface ServiceConnection
{
    default void onBindingDied(ComponentName p0){}
    default void onNullBinding(ComponentName p0){}
    void onServiceConnected(ComponentName p0, IBinder p1);
    void onServiceDisconnected(ComponentName p0);
}
