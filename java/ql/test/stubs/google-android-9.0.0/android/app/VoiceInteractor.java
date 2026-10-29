// Generated automatically from android.app.VoiceInteractor for testing purposes

package android.app;

import android.app.Activity;
import android.content.Context;
import java.util.concurrent.Executor;

public class VoiceInteractor
{
    abstract static public class Request
    {
        public Activity getActivity(){ return null; }
        public Context getContext(){ return null; }
        public String getName(){ return null; }
        public String toString(){ return null; }
        public void cancel(){}
        public void onAttached(Activity p0){}
        public void onCancel(){}
        public void onDetached(){}
    }
    public VoiceInteractor.Request getActiveRequest(String p0){ return null; }
    public VoiceInteractor.Request[] getActiveRequests(){ return null; }
    public boolean isDestroyed(){ return false; }
    public boolean registerOnDestroyedCallback(Executor p0, Runnable p1){ return false; }
    public boolean submitRequest(VoiceInteractor.Request p0){ return false; }
    public boolean submitRequest(VoiceInteractor.Request p0, String p1){ return false; }
    public boolean unregisterOnDestroyedCallback(Runnable p0){ return false; }
    public boolean[] supportsCommands(String[] p0){ return null; }
    public void notifyDirectActionsChanged(){}
}
