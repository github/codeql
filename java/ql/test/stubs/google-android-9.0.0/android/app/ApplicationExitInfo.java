// Generated automatically from android.app.ApplicationExitInfo for testing purposes

package android.app;

import android.os.Parcel;
import android.os.Parcelable;
import android.os.UserHandle;
import java.io.InputStream;

public class ApplicationExitInfo implements Parcelable
{
    public InputStream getTraceInputStream(){ return null; }
    public String getDescription(){ return null; }
    public String getProcessName(){ return null; }
    public String toString(){ return null; }
    public UserHandle getUserHandle(){ return null; }
    public boolean equals(Object p0){ return false; }
    public byte[] getProcessStateSummary(){ return null; }
    public int describeContents(){ return 0; }
    public int getDefiningUid(){ return 0; }
    public int getImportance(){ return 0; }
    public int getPackageUid(){ return 0; }
    public int getPid(){ return 0; }
    public int getRealUid(){ return 0; }
    public int getReason(){ return 0; }
    public int getStatus(){ return 0; }
    public int hashCode(){ return 0; }
    public long getPss(){ return 0; }
    public long getRss(){ return 0; }
    public long getTimestamp(){ return 0; }
    public static Parcelable.Creator<ApplicationExitInfo> CREATOR = null;
    public static int REASON_ANR = 0;
    public static int REASON_CRASH = 0;
    public static int REASON_CRASH_NATIVE = 0;
    public static int REASON_DEPENDENCY_DIED = 0;
    public static int REASON_EXCESSIVE_RESOURCE_USAGE = 0;
    public static int REASON_EXIT_SELF = 0;
    public static int REASON_INITIALIZATION_FAILURE = 0;
    public static int REASON_LOW_MEMORY = 0;
    public static int REASON_OTHER = 0;
    public static int REASON_PERMISSION_CHANGE = 0;
    public static int REASON_SIGNALED = 0;
    public static int REASON_UNKNOWN = 0;
    public static int REASON_USER_REQUESTED = 0;
    public static int REASON_USER_STOPPED = 0;
    public void writeToParcel(Parcel p0, int p1){}
}
