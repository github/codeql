// Generated automatically from android.os.IBinder for testing purposes

package android.os;

import android.os.IInterface;
import android.os.Parcel;
import java.io.FileDescriptor;

public interface IBinder
{
    IInterface queryLocalInterface(String p0);
    String getInterfaceDescriptor();
    boolean isBinderAlive();
    boolean pingBinder();
    boolean transact(int p0, Parcel p1, Parcel p2, int p3);
    boolean unlinkToDeath(IBinder.DeathRecipient p0, int p1);
    static int DUMP_TRANSACTION = 0;
    static int FIRST_CALL_TRANSACTION = 0;
    static int FLAG_ONEWAY = 0;
    static int INTERFACE_TRANSACTION = 0;
    static int LAST_CALL_TRANSACTION = 0;
    static int LIKE_TRANSACTION = 0;
    static int PING_TRANSACTION = 0;
    static int TWEET_TRANSACTION = 0;
    static int getSuggestedMaxIpcSizeBytes(){ return 0; }
    static public interface DeathRecipient
    {
        void binderDied();
    }
    void dump(FileDescriptor p0, String[] p1);
    void dumpAsync(FileDescriptor p0, String[] p1);
    void linkToDeath(IBinder.DeathRecipient p0, int p1);
}
