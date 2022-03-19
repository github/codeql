// Generated automatically from android.view.Surface for testing purposes

package android.view;

import android.graphics.Canvas;
import android.graphics.Rect;
import android.graphics.SurfaceTexture;
import android.os.Parcel;
import android.os.Parcelable;
import android.view.SurfaceControl;

public class Surface implements Parcelable
{
    protected Surface() {}
    protected void finalize(){}
    public Canvas lockCanvas(Rect p0){ return null; }
    public Canvas lockHardwareCanvas(){ return null; }
    public String toString(){ return null; }
    public Surface(SurfaceControl p0){}
    public Surface(SurfaceTexture p0){}
    public boolean isValid(){ return false; }
    public int describeContents(){ return 0; }
    public static Parcelable.Creator<Surface> CREATOR = null;
    public static int CHANGE_FRAME_RATE_ALWAYS = 0;
    public static int CHANGE_FRAME_RATE_ONLY_IF_SEAMLESS = 0;
    public static int FRAME_RATE_COMPATIBILITY_DEFAULT = 0;
    public static int FRAME_RATE_COMPATIBILITY_FIXED_SOURCE = 0;
    public static int ROTATION_0 = 0;
    public static int ROTATION_180 = 0;
    public static int ROTATION_270 = 0;
    public static int ROTATION_90 = 0;
    public void readFromParcel(Parcel p0){}
    public void release(){}
    public void setFrameRate(float p0, int p1){}
    public void setFrameRate(float p0, int p1, int p2){}
    public void unlockCanvas(Canvas p0){}
    public void unlockCanvasAndPost(Canvas p0){}
    public void writeToParcel(Parcel p0, int p1){}
    static public class OutOfResourcesException extends RuntimeException
    {
        public OutOfResourcesException(){}
        public OutOfResourcesException(String p0){}
    }
}
