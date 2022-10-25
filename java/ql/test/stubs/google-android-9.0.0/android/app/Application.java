// Generated automatically from android.app.Application for testing purposes

package android.app;

import android.app.Activity;
import android.content.ComponentCallbacks2;
import android.content.ComponentCallbacks;
import android.content.ContextWrapper;
import android.content.res.Configuration;
import android.os.Bundle;

public class Application extends ContextWrapper implements ComponentCallbacks2
{
    public Application(){}
    public static String getProcessName(){ return null; }
    public void onConfigurationChanged(Configuration p0){}
    public void onCreate(){}
    public void onLowMemory(){}
    public void onTerminate(){}
    public void onTrimMemory(int p0){}
    public void registerActivityLifecycleCallbacks(Application.ActivityLifecycleCallbacks p0){}
    public void registerComponentCallbacks(ComponentCallbacks p0){}
    public void registerOnProvideAssistDataListener(Application.OnProvideAssistDataListener p0){}
    public void unregisterActivityLifecycleCallbacks(Application.ActivityLifecycleCallbacks p0){}
    public void unregisterComponentCallbacks(ComponentCallbacks p0){}
    public void unregisterOnProvideAssistDataListener(Application.OnProvideAssistDataListener p0){}
    static public interface ActivityLifecycleCallbacks
    {
        default void onActivityPostCreated(Activity p0, Bundle p1){}
        default void onActivityPostDestroyed(Activity p0){}
        default void onActivityPostPaused(Activity p0){}
        default void onActivityPostResumed(Activity p0){}
        default void onActivityPostSaveInstanceState(Activity p0, Bundle p1){}
        default void onActivityPostStarted(Activity p0){}
        default void onActivityPostStopped(Activity p0){}
        default void onActivityPreCreated(Activity p0, Bundle p1){}
        default void onActivityPreDestroyed(Activity p0){}
        default void onActivityPrePaused(Activity p0){}
        default void onActivityPreResumed(Activity p0){}
        default void onActivityPreSaveInstanceState(Activity p0, Bundle p1){}
        default void onActivityPreStarted(Activity p0){}
        default void onActivityPreStopped(Activity p0){}
        void onActivityCreated(Activity p0, Bundle p1);
        void onActivityDestroyed(Activity p0);
        void onActivityPaused(Activity p0);
        void onActivityResumed(Activity p0);
        void onActivitySaveInstanceState(Activity p0, Bundle p1);
        void onActivityStarted(Activity p0);
        void onActivityStopped(Activity p0);
    }
    static public interface OnProvideAssistDataListener
    {
        void onProvideAssistData(Activity p0, Bundle p1);
    }
}
