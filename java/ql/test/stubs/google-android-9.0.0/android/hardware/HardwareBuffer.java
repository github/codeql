// Generated automatically from android.hardware.HardwareBuffer for testing purposes

package android.hardware;

import android.os.Parcel;
import android.os.Parcelable;

public class HardwareBuffer implements AutoCloseable, Parcelable
{
    protected HardwareBuffer() {}
    protected void finalize(){}
    public boolean isClosed(){ return false; }
    public int describeContents(){ return 0; }
    public int getFormat(){ return 0; }
    public int getHeight(){ return 0; }
    public int getLayers(){ return 0; }
    public int getWidth(){ return 0; }
    public long getUsage(){ return 0; }
    public static HardwareBuffer create(int p0, int p1, int p2, int p3, long p4){ return null; }
    public static Parcelable.Creator<HardwareBuffer> CREATOR = null;
    public static boolean isSupported(int p0, int p1, int p2, int p3, long p4){ return false; }
    public static int BLOB = 0;
    public static int DS_24UI8 = 0;
    public static int DS_FP32UI8 = 0;
    public static int D_16 = 0;
    public static int D_24 = 0;
    public static int D_FP32 = 0;
    public static int RGBA_1010102 = 0;
    public static int RGBA_8888 = 0;
    public static int RGBA_FP16 = 0;
    public static int RGBX_8888 = 0;
    public static int RGB_565 = 0;
    public static int RGB_888 = 0;
    public static int S_UI8 = 0;
    public static int YCBCR_420_888 = 0;
    public static long USAGE_CPU_READ_OFTEN = 0;
    public static long USAGE_CPU_READ_RARELY = 0;
    public static long USAGE_CPU_WRITE_OFTEN = 0;
    public static long USAGE_CPU_WRITE_RARELY = 0;
    public static long USAGE_GPU_COLOR_OUTPUT = 0;
    public static long USAGE_GPU_CUBE_MAP = 0;
    public static long USAGE_GPU_DATA_BUFFER = 0;
    public static long USAGE_GPU_MIPMAP_COMPLETE = 0;
    public static long USAGE_GPU_SAMPLED_IMAGE = 0;
    public static long USAGE_PROTECTED_CONTENT = 0;
    public static long USAGE_SENSOR_DIRECT_DATA = 0;
    public static long USAGE_VIDEO_ENCODE = 0;
    public void close(){}
    public void writeToParcel(Parcel p0, int p1){}
}
