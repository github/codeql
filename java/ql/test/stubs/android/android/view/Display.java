// Generated automatically from android.view.Display for testing purposes

package android.view;

import android.graphics.ColorSpace;
import android.graphics.Point;
import android.graphics.Rect;
import android.os.Parcel;
import android.os.Parcelable;
import android.util.DisplayMetrics;
import android.view.DisplayCutout;

public class Display
{
    public ColorSpace getPreferredWideGamutColorSpace(){ return null; }
    public Display.HdrCapabilities getHdrCapabilities(){ return null; }
    public Display.Mode getMode(){ return null; }
    public Display.Mode[] getSupportedModes(){ return null; }
    public DisplayCutout getCutout(){ return null; }
    public String getName(){ return null; }
    public String toString(){ return null; }
    public boolean isHdr(){ return false; }
    public boolean isMinimalPostProcessingSupported(){ return false; }
    public boolean isValid(){ return false; }
    public boolean isWideColorGamut(){ return false; }
    public float getRefreshRate(){ return 0; }
    public float[] getSupportedRefreshRates(){ return null; }
    public int getDisplayId(){ return 0; }
    public int getFlags(){ return 0; }
    public int getHeight(){ return 0; }
    public int getOrientation(){ return 0; }
    public int getPixelFormat(){ return 0; }
    public int getRotation(){ return 0; }
    public int getState(){ return 0; }
    public int getWidth(){ return 0; }
    public long getAppVsyncOffsetNanos(){ return 0; }
    public long getPresentationDeadlineNanos(){ return 0; }
    public static int DEFAULT_DISPLAY = 0;
    public static int FLAG_PRESENTATION = 0;
    public static int FLAG_PRIVATE = 0;
    public static int FLAG_ROUND = 0;
    public static int FLAG_SECURE = 0;
    public static int FLAG_SUPPORTS_PROTECTED_BUFFERS = 0;
    public static int INVALID_DISPLAY = 0;
    public static int STATE_DOZE = 0;
    public static int STATE_DOZE_SUSPEND = 0;
    public static int STATE_OFF = 0;
    public static int STATE_ON = 0;
    public static int STATE_ON_SUSPEND = 0;
    public static int STATE_UNKNOWN = 0;
    public static int STATE_VR = 0;
    public void getCurrentSizeRange(Point p0, Point p1){}
    public void getMetrics(DisplayMetrics p0){}
    public void getRealMetrics(DisplayMetrics p0){}
    public void getRealSize(Point p0){}
    public void getRectSize(Rect p0){}
    public void getSize(Point p0){}
    static public class HdrCapabilities implements Parcelable
    {
        public String toString(){ return null; }
        public boolean equals(Object p0){ return false; }
        public float getDesiredMaxAverageLuminance(){ return 0; }
        public float getDesiredMaxLuminance(){ return 0; }
        public float getDesiredMinLuminance(){ return 0; }
        public int describeContents(){ return 0; }
        public int hashCode(){ return 0; }
        public int[] getSupportedHdrTypes(){ return null; }
        public static Parcelable.Creator<Display.HdrCapabilities> CREATOR = null;
        public static float INVALID_LUMINANCE = 0;
        public static int HDR_TYPE_DOLBY_VISION = 0;
        public static int HDR_TYPE_HDR10 = 0;
        public static int HDR_TYPE_HDR10_PLUS = 0;
        public static int HDR_TYPE_HLG = 0;
        public void writeToParcel(Parcel p0, int p1){}
    }
    static public class Mode implements Parcelable
    {
        public String toString(){ return null; }
        public boolean equals(Object p0){ return false; }
        public float getRefreshRate(){ return 0; }
        public int describeContents(){ return 0; }
        public int getModeId(){ return 0; }
        public int getPhysicalHeight(){ return 0; }
        public int getPhysicalWidth(){ return 0; }
        public int hashCode(){ return 0; }
        public static Parcelable.Creator<Display.Mode> CREATOR = null;
        public void writeToParcel(Parcel p0, int p1){}
    }
}
