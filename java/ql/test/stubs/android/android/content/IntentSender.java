// Generated automatically from android.content.IntentSender for testing purposes

package android.content;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Parcel;
import android.os.Parcelable;
import android.os.UserHandle;
import android.util.AndroidException;

public class IntentSender implements Parcelable
{
    public String getCreatorPackage(){ return null; }
    public String getTargetPackage(){ return null; }
    public String toString(){ return null; }
    public UserHandle getCreatorUserHandle(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int describeContents(){ return 0; }
    public int getCreatorUid(){ return 0; }
    public int hashCode(){ return 0; }
    public static IntentSender readIntentSenderOrNullFromParcel(Parcel p0){ return null; }
    public static Parcelable.Creator<IntentSender> CREATOR = null;
    public static void writeIntentSenderOrNullToParcel(IntentSender p0, Parcel p1){}
    public void sendIntent(Context p0, int p1, Intent p2, IntentSender.OnFinished p3, Handler p4){}
    public void sendIntent(Context p0, int p1, Intent p2, IntentSender.OnFinished p3, Handler p4, String p5){}
    public void writeToParcel(Parcel p0, int p1){}
    static public class SendIntentException extends AndroidException
    {
        public SendIntentException(){}
        public SendIntentException(Exception p0){}
        public SendIntentException(String p0){}
    }
    static public interface OnFinished
    {
        void onSendFinished(IntentSender p0, Intent p1, int p2, String p3, Bundle p4);
    }
}
