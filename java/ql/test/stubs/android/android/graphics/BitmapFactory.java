// Generated automatically from android.graphics.BitmapFactory for testing purposes

package android.graphics;

import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.ColorSpace;
import android.graphics.Rect;
import android.util.TypedValue;
import java.io.FileDescriptor;
import java.io.InputStream;

public class BitmapFactory
{
    public BitmapFactory(){}
    public static Bitmap decodeByteArray(byte[] p0, int p1, int p2){ return null; }
    public static Bitmap decodeByteArray(byte[] p0, int p1, int p2, BitmapFactory.Options p3){ return null; }
    public static Bitmap decodeFile(String p0){ return null; }
    public static Bitmap decodeFile(String p0, BitmapFactory.Options p1){ return null; }
    public static Bitmap decodeFileDescriptor(FileDescriptor p0){ return null; }
    public static Bitmap decodeFileDescriptor(FileDescriptor p0, Rect p1, BitmapFactory.Options p2){ return null; }
    public static Bitmap decodeResource(Resources p0, int p1){ return null; }
    public static Bitmap decodeResource(Resources p0, int p1, BitmapFactory.Options p2){ return null; }
    public static Bitmap decodeResourceStream(Resources p0, TypedValue p1, InputStream p2, Rect p3, BitmapFactory.Options p4){ return null; }
    public static Bitmap decodeStream(InputStream p0){ return null; }
    public static Bitmap decodeStream(InputStream p0, Rect p1, BitmapFactory.Options p2){ return null; }
    static public class Options
    {
        public Bitmap inBitmap = null;
        public Bitmap.Config inPreferredConfig = null;
        public Bitmap.Config outConfig = null;
        public ColorSpace inPreferredColorSpace = null;
        public ColorSpace outColorSpace = null;
        public Options(){}
        public String outMimeType = null;
        public boolean inDither = false;
        public boolean inInputShareable = false;
        public boolean inJustDecodeBounds = false;
        public boolean inMutable = false;
        public boolean inPreferQualityOverSpeed = false;
        public boolean inPremultiplied = false;
        public boolean inPurgeable = false;
        public boolean inScaled = false;
        public boolean mCancel = false;
        public byte[] inTempStorage = null;
        public int inDensity = 0;
        public int inSampleSize = 0;
        public int inScreenDensity = 0;
        public int inTargetDensity = 0;
        public int outHeight = 0;
        public int outWidth = 0;
        public void requestCancelDecode(){}
    }
}
