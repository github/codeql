// Generated automatically from android.graphics.Bitmap for testing purposes

package android.graphics;

import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.ColorSpace;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Picture;
import android.hardware.HardwareBuffer;
import android.os.Parcel;
import android.os.Parcelable;
import android.util.DisplayMetrics;
import java.io.OutputStream;
import java.nio.Buffer;

public class Bitmap implements Parcelable
{
    public Bitmap asShared(){ return null; }
    public Bitmap copy(Bitmap.Config p0, boolean p1){ return null; }
    public Bitmap extractAlpha(){ return null; }
    public Bitmap extractAlpha(Paint p0, int[] p1){ return null; }
    public Bitmap.Config getConfig(){ return null; }
    public Color getColor(int p0, int p1){ return null; }
    public ColorSpace getColorSpace(){ return null; }
    public HardwareBuffer getHardwareBuffer(){ return null; }
    public boolean compress(Bitmap.CompressFormat p0, int p1, OutputStream p2){ return false; }
    public boolean hasAlpha(){ return false; }
    public boolean hasMipMap(){ return false; }
    public boolean isMutable(){ return false; }
    public boolean isPremultiplied(){ return false; }
    public boolean isRecycled(){ return false; }
    public boolean sameAs(Bitmap p0){ return false; }
    public byte[] getNinePatchChunk(){ return null; }
    public int describeContents(){ return 0; }
    public int getAllocationByteCount(){ return 0; }
    public int getByteCount(){ return 0; }
    public int getDensity(){ return 0; }
    public int getGenerationId(){ return 0; }
    public int getHeight(){ return 0; }
    public int getPixel(int p0, int p1){ return 0; }
    public int getRowBytes(){ return 0; }
    public int getScaledHeight(Canvas p0){ return 0; }
    public int getScaledHeight(DisplayMetrics p0){ return 0; }
    public int getScaledHeight(int p0){ return 0; }
    public int getScaledWidth(Canvas p0){ return 0; }
    public int getScaledWidth(DisplayMetrics p0){ return 0; }
    public int getScaledWidth(int p0){ return 0; }
    public int getWidth(){ return 0; }
    public static Bitmap createBitmap(Bitmap p0){ return null; }
    public static Bitmap createBitmap(Bitmap p0, int p1, int p2, int p3, int p4){ return null; }
    public static Bitmap createBitmap(Bitmap p0, int p1, int p2, int p3, int p4, Matrix p5, boolean p6){ return null; }
    public static Bitmap createBitmap(DisplayMetrics p0, int p1, int p2, Bitmap.Config p3){ return null; }
    public static Bitmap createBitmap(DisplayMetrics p0, int p1, int p2, Bitmap.Config p3, boolean p4){ return null; }
    public static Bitmap createBitmap(DisplayMetrics p0, int p1, int p2, Bitmap.Config p3, boolean p4, ColorSpace p5){ return null; }
    public static Bitmap createBitmap(DisplayMetrics p0, int[] p1, int p2, int p3, Bitmap.Config p4){ return null; }
    public static Bitmap createBitmap(DisplayMetrics p0, int[] p1, int p2, int p3, int p4, int p5, Bitmap.Config p6){ return null; }
    public static Bitmap createBitmap(Picture p0){ return null; }
    public static Bitmap createBitmap(Picture p0, int p1, int p2, Bitmap.Config p3){ return null; }
    public static Bitmap createBitmap(int p0, int p1, Bitmap.Config p2){ return null; }
    public static Bitmap createBitmap(int p0, int p1, Bitmap.Config p2, boolean p3){ return null; }
    public static Bitmap createBitmap(int p0, int p1, Bitmap.Config p2, boolean p3, ColorSpace p4){ return null; }
    public static Bitmap createBitmap(int[] p0, int p1, int p2, Bitmap.Config p3){ return null; }
    public static Bitmap createBitmap(int[] p0, int p1, int p2, int p3, int p4, Bitmap.Config p5){ return null; }
    public static Bitmap createScaledBitmap(Bitmap p0, int p1, int p2, boolean p3){ return null; }
    public static Bitmap wrapHardwareBuffer(HardwareBuffer p0, ColorSpace p1){ return null; }
    public static Parcelable.Creator<Bitmap> CREATOR = null;
    public static int DENSITY_NONE = 0;
    public void copyPixelsFromBuffer(Buffer p0){}
    public void copyPixelsToBuffer(Buffer p0){}
    public void eraseColor(int p0){}
    public void eraseColor(long p0){}
    public void getPixels(int[] p0, int p1, int p2, int p3, int p4, int p5, int p6){}
    public void prepareToDraw(){}
    public void reconfigure(int p0, int p1, Bitmap.Config p2){}
    public void recycle(){}
    public void setColorSpace(ColorSpace p0){}
    public void setConfig(Bitmap.Config p0){}
    public void setDensity(int p0){}
    public void setHasAlpha(boolean p0){}
    public void setHasMipMap(boolean p0){}
    public void setHeight(int p0){}
    public void setPixel(int p0, int p1, int p2){}
    public void setPixels(int[] p0, int p1, int p2, int p3, int p4, int p5, int p6){}
    public void setPremultiplied(boolean p0){}
    public void setWidth(int p0){}
    public void writeToParcel(Parcel p0, int p1){}
    static public enum CompressFormat
    {
        JPEG, PNG, WEBP, WEBP_LOSSLESS, WEBP_LOSSY;
        private CompressFormat() {}
    }
    static public enum Config
    {
        ALPHA_8, ARGB_4444, ARGB_8888, HARDWARE, RGBA_F16, RGB_565;
        private Config() {}
    }
}
