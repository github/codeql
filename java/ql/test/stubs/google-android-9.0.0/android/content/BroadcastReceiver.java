// Generated automatically from android.content.BroadcastReceiver for testing purposes

package android.content;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.IBinder;

abstract public class BroadcastReceiver
{
    public BroadcastReceiver(){}
    public IBinder peekService(Context p0, Intent p1){ return null; }
    public abstract void onReceive(Context p0, Intent p1);
    public final BroadcastReceiver.PendingResult goAsync(){ return null; }
    public final Bundle getResultExtras(boolean p0){ return null; }
    public final String getResultData(){ return null; }
    public final boolean getAbortBroadcast(){ return false; }
    public final boolean getDebugUnregister(){ return false; }
    public final boolean isInitialStickyBroadcast(){ return false; }
    public final boolean isOrderedBroadcast(){ return false; }
    public final int getResultCode(){ return 0; }
    public final void abortBroadcast(){}
    public final void clearAbortBroadcast(){}
    public final void setDebugUnregister(boolean p0){}
    public final void setOrderedHint(boolean p0){}
    public final void setResult(int p0, String p1, Bundle p2){}
    public final void setResultCode(int p0){}
    public final void setResultData(String p0){}
    public final void setResultExtras(Bundle p0){}
    static public class PendingResult
    {
        public final Bundle getResultExtras(boolean p0){ return null; }
        public final String getResultData(){ return null; }
        public final boolean getAbortBroadcast(){ return false; }
        public final int getResultCode(){ return 0; }
        public final void abortBroadcast(){}
        public final void clearAbortBroadcast(){}
        public final void finish(){}
        public final void setResult(int p0, String p1, Bundle p2){}
        public final void setResultCode(int p0){}
        public final void setResultData(String p0){}
        public final void setResultExtras(Bundle p0){}
    }
}
