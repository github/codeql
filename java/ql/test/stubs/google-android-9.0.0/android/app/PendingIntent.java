// Generated automatically from android.app.PendingIntent for testing purposes

package android.app;

import android.content.Context;
import android.content.Intent;
import android.content.IntentSender;
import android.os.Bundle;
import android.os.Handler;
import android.os.Parcel;
import android.os.Parcelable;
import android.os.UserHandle;
import android.util.AndroidException;

public class PendingIntent implements Parcelable
{
    public IntentSender getIntentSender(){ return null; }
    public String getCreatorPackage(){ return null; }
    public String getTargetPackage(){ return null; }
    public String toString(){ return null; }
    public UserHandle getCreatorUserHandle(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean isActivity(){ return false; }
    public boolean isBroadcast(){ return false; }
    public boolean isForegroundService(){ return false; }
    public boolean isImmutable(){ return false; }
    public boolean isService(){ return false; }
    public int describeContents(){ return 0; }
    public int getCreatorUid(){ return 0; }
    public int hashCode(){ return 0; }
    public static Parcelable.Creator<PendingIntent> CREATOR = null;
    public static PendingIntent getActivities(Context p0, int p1, Intent[] p2, int p3){ return null; }
    public static PendingIntent getActivities(Context p0, int p1, Intent[] p2, int p3, Bundle p4){ return null; }
    public static PendingIntent getActivitiesAsUser(Context p0, int p1, Intent[] p3, int p4, Bundle p5, UserHandle p6) { return null; }
    public static PendingIntent getActivity(Context p0, int p1, Intent p2, int p3){ return null; }
    public static PendingIntent getActivity(Context p0, int p1, Intent p2, int p3, Bundle p4){ return null; }
    public static PendingIntent getActivityAsUser(Context p0, int p1, Intent p2, int p3, Bundle p4, UserHandle p5) { return null; }
    public static PendingIntent getBroadcast(Context p0, int p1, Intent p2, int p3){ return null; }
    public static PendingIntent getBroadcastAsUser(Context p0, int p1, Intent p2, int p3, UserHandle p4) { return null; }
    public static PendingIntent getForegroundService(Context p0, int p1, Intent p2, int p3){ return null; }
    public static PendingIntent getService(Context p0, int p1, Intent p2, int p3){ return null; }
    public static PendingIntent readPendingIntentOrNullFromParcel(Parcel p0){ return null; }
    public static int FLAG_CANCEL_CURRENT = 0;
    public static int FLAG_IMMUTABLE = 0;
    public static int FLAG_MUTABLE = 0;
    public static int FLAG_NO_CREATE = 0;
    public static int FLAG_ONE_SHOT = 0;
    public static int FLAG_UPDATE_CURRENT = 0;
    public static void writePendingIntentOrNullToParcel(PendingIntent p0, Parcel p1){}
    public void cancel(){}
    public void send(){}
    public void send(Context p0, int p1, Intent p2){}
    public void send(Context p0, int p1, Intent p2, PendingIntent.OnFinished p3, Handler p4){}
    public void send(Context p0, int p1, Intent p2, PendingIntent.OnFinished p3, Handler p4, String p5){}
    public void send(Context p0, int p1, Intent p2, PendingIntent.OnFinished p3, Handler p4, String p5, Bundle p6){}
    public void send(int p0){}
    public void send(int p0, PendingIntent.OnFinished p1, Handler p2){}
    public void writeToParcel(Parcel p0, int p1){}
    static public class CanceledException extends AndroidException
    {
        public CanceledException(){}
        public CanceledException(Exception p0){}
        public CanceledException(String p0){}
    }
    static public interface OnFinished
    {
        void onSendFinished(PendingIntent p0, Intent p1, int p2, String p3, Bundle p4);
    }
}
