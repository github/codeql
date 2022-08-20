// Generated automatically from android.graphics.drawable.Icon for testing purposes

package android.graphics.drawable;

import android.content.Context;
import android.content.res.ColorStateList;
import android.graphics.Bitmap;
import android.graphics.BlendMode;
import android.graphics.PorterDuff;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Handler;
import android.os.Message;
import android.os.Parcel;
import android.os.Parcelable;

public class Icon implements Parcelable
{
    protected Icon() {}
    public Drawable loadDrawable(Context p0){ return null; }
    public Icon setTint(int p0){ return null; }
    public Icon setTintBlendMode(BlendMode p0){ return null; }
    public Icon setTintList(ColorStateList p0){ return null; }
    public Icon setTintMode(PorterDuff.Mode p0){ return null; }
    public String getResPackage(){ return null; }
    public String toString(){ return null; }
    public Uri getUri(){ return null; }
    public int describeContents(){ return 0; }
    public int getResId(){ return 0; }
    public int getType(){ return 0; }
    public static Icon createWithAdaptiveBitmap(Bitmap p0){ return null; }
    public static Icon createWithAdaptiveBitmapContentUri(String p0){ return null; }
    public static Icon createWithAdaptiveBitmapContentUri(Uri p0){ return null; }
    public static Icon createWithBitmap(Bitmap p0){ return null; }
    public static Icon createWithContentUri(String p0){ return null; }
    public static Icon createWithContentUri(Uri p0){ return null; }
    public static Icon createWithData(byte[] p0, int p1, int p2){ return null; }
    public static Icon createWithFilePath(String p0){ return null; }
    public static Icon createWithResource(Context p0, int p1){ return null; }
    public static Icon createWithResource(String p0, int p1){ return null; }
    public static Parcelable.Creator<Icon> CREATOR = null;
    public static int TYPE_ADAPTIVE_BITMAP = 0;
    public static int TYPE_BITMAP = 0;
    public static int TYPE_DATA = 0;
    public static int TYPE_RESOURCE = 0;
    public static int TYPE_URI = 0;
    public static int TYPE_URI_ADAPTIVE_BITMAP = 0;
    public void loadDrawableAsync(Context p0, Icon.OnDrawableLoadedListener p1, Handler p2){}
    public void loadDrawableAsync(Context p0, Message p1){}
    public void writeToParcel(Parcel p0, int p1){}
    static public interface OnDrawableLoadedListener
    {
        void onDrawableLoaded(Drawable p0);
    }
}
