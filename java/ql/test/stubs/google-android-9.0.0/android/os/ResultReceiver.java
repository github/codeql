// Generated automatically from android.os.ResultReceiver for testing purposes

package android.os;

import android.os.Bundle;
import android.os.Handler;
import android.os.Parcel;
import android.os.Parcelable;

public class ResultReceiver implements Parcelable
{
    protected ResultReceiver() {}
    protected void onReceiveResult(int p0, Bundle p1){}
    public ResultReceiver(Handler p0){}
    public int describeContents(){ return 0; }
    public static Parcelable.Creator<ResultReceiver> CREATOR = null;
    public void send(int p0, Bundle p1){}
    public void writeToParcel(Parcel p0, int p1){}
}
