// Generated automatically from android.view.SurfaceControl for testing purposes

package android.view;

import android.graphics.Rect;
import android.os.Parcel;
import android.os.Parcelable;
import java.io.Closeable;

public class SurfaceControl implements Parcelable
{
    protected void finalize(){}
    public String toString(){ return null; }
    public boolean isValid(){ return false; }
    public int describeContents(){ return 0; }
    public static Parcelable.Creator<SurfaceControl> CREATOR = null;
    public void readFromParcel(Parcel p0){}
    public void release(){}
    public void writeToParcel(Parcel p0, int p1){}
    static public class Transaction implements Closeable, Parcelable
    {
        public SurfaceControl.Transaction merge(SurfaceControl.Transaction p0){ return null; }
        public SurfaceControl.Transaction reparent(SurfaceControl p0, SurfaceControl p1){ return null; }
        public SurfaceControl.Transaction setAlpha(SurfaceControl p0, float p1){ return null; }
        public SurfaceControl.Transaction setBufferSize(SurfaceControl p0, int p1, int p2){ return null; }
        public SurfaceControl.Transaction setFrameRate(SurfaceControl p0, float p1, int p2){ return null; }
        public SurfaceControl.Transaction setFrameRate(SurfaceControl p0, float p1, int p2, int p3){ return null; }
        public SurfaceControl.Transaction setGeometry(SurfaceControl p0, Rect p1, Rect p2, int p3){ return null; }
        public SurfaceControl.Transaction setLayer(SurfaceControl p0, int p1){ return null; }
        public SurfaceControl.Transaction setVisibility(SurfaceControl p0, boolean p1){ return null; }
        public Transaction(){}
        public int describeContents(){ return 0; }
        public static Parcelable.Creator<SurfaceControl.Transaction> CREATOR = null;
        public void apply(){}
        public void close(){}
        public void writeToParcel(Parcel p0, int p1){}
    }
}
