// Generated automatically from android.content.res.AssetFileDescriptor for testing purposes

package android.content.res;

import android.os.Bundle;
import android.os.Parcel;
import android.os.ParcelFileDescriptor;
import android.os.Parcelable;
import java.io.Closeable;
import java.io.FileDescriptor;
import java.io.FileInputStream;
import java.io.FileOutputStream;

public class AssetFileDescriptor implements Closeable, Parcelable
{
    protected AssetFileDescriptor() {}
    public AssetFileDescriptor(ParcelFileDescriptor p0, long p1, long p2){}
    public AssetFileDescriptor(ParcelFileDescriptor p0, long p1, long p2, Bundle p3){}
    public Bundle getExtras(){ return null; }
    public FileDescriptor getFileDescriptor(){ return null; }
    public FileInputStream createInputStream(){ return null; }
    public FileOutputStream createOutputStream(){ return null; }
    public ParcelFileDescriptor getParcelFileDescriptor(){ return null; }
    public String toString(){ return null; }
    public int describeContents(){ return 0; }
    public long getDeclaredLength(){ return 0; }
    public long getLength(){ return 0; }
    public long getStartOffset(){ return 0; }
    public static Parcelable.Creator<AssetFileDescriptor> CREATOR = null;
    public static long UNKNOWN_LENGTH = 0;
    public void close(){}
    public void writeToParcel(Parcel p0, int p1){}
}
