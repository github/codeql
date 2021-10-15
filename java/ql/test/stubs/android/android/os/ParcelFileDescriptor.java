// Generated automatically from android.os.ParcelFileDescriptor for testing purposes

package android.os;

import android.os.Handler;
import android.os.Parcel;
import android.os.Parcelable;
import java.io.Closeable;
import java.io.File;
import java.io.FileDescriptor;
import java.io.IOException;
import java.net.DatagramSocket;
import java.net.Socket;

public class ParcelFileDescriptor implements Closeable, Parcelable
{
    protected ParcelFileDescriptor() {}
    protected void finalize(){}
    public FileDescriptor getFileDescriptor(){ return null; }
    public ParcelFileDescriptor dup(){ return null; }
    public ParcelFileDescriptor(ParcelFileDescriptor p0){}
    public String toString(){ return null; }
    public boolean canDetectErrors(){ return false; }
    public int describeContents(){ return 0; }
    public int detachFd(){ return 0; }
    public int getFd(){ return 0; }
    public long getStatSize(){ return 0; }
    public static ParcelFileDescriptor adoptFd(int p0){ return null; }
    public static ParcelFileDescriptor dup(FileDescriptor p0){ return null; }
    public static ParcelFileDescriptor fromDatagramSocket(DatagramSocket p0){ return null; }
    public static ParcelFileDescriptor fromFd(int p0){ return null; }
    public static ParcelFileDescriptor fromSocket(Socket p0){ return null; }
    public static ParcelFileDescriptor open(File p0, int p1){ return null; }
    public static ParcelFileDescriptor open(File p0, int p1, Handler p2, ParcelFileDescriptor.OnCloseListener p3){ return null; }
    public static ParcelFileDescriptor wrap(ParcelFileDescriptor p0, Handler p1, ParcelFileDescriptor.OnCloseListener p2){ return null; }
    public static ParcelFileDescriptor[] createPipe(){ return null; }
    public static ParcelFileDescriptor[] createReliablePipe(){ return null; }
    public static ParcelFileDescriptor[] createReliableSocketPair(){ return null; }
    public static ParcelFileDescriptor[] createSocketPair(){ return null; }
    public static Parcelable.Creator<ParcelFileDescriptor> CREATOR = null;
    public static int MODE_APPEND = 0;
    public static int MODE_CREATE = 0;
    public static int MODE_READ_ONLY = 0;
    public static int MODE_READ_WRITE = 0;
    public static int MODE_TRUNCATE = 0;
    public static int MODE_WORLD_READABLE = 0;
    public static int MODE_WORLD_WRITEABLE = 0;
    public static int MODE_WRITE_ONLY = 0;
    public static int parseMode(String p0){ return 0; }
    public void checkError(){}
    public void close(){}
    public void closeWithError(String p0){}
    public void writeToParcel(Parcel p0, int p1){}
    static public interface OnCloseListener
    {
        void onClose(IOException p0);
    }
}
