// Generated automatically from android.os.Messenger for testing purposes

package android.os;

import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.os.Parcel;
import android.os.Parcelable;

public class Messenger implements Parcelable
{
    protected Messenger() {}
    public IBinder getBinder(){ return null; }
    public Messenger(Handler p0){}
    public Messenger(IBinder p0){}
    public boolean equals(Object p0){ return false; }
    public int describeContents(){ return 0; }
    public int hashCode(){ return 0; }
    public static Messenger readMessengerOrNullFromParcel(Parcel p0){ return null; }
    public static Parcelable.Creator<Messenger> CREATOR = null;
    public static void writeMessengerOrNullToParcel(Messenger p0, Parcel p1){}
    public void send(Message p0){}
    public void writeToParcel(Parcel p0, int p1){}
}
