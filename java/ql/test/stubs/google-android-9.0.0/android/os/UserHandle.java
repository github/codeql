// Generated automatically from android.os.UserHandle for testing purposes

package android.os;

import java.io.PrintWriter;

public class UserHandle implements Parcelable
{
    protected UserHandle() {}
    public String toString(){ return null; }
    public UserHandle(Parcel p0){}
    public boolean equals(Object p0){ return false; }
    public int describeContents(){ return 0; }
    public int hashCode(){ return 0; }
    public static Parcelable.Creator<UserHandle> CREATOR = null;
    public static UserHandle getUserHandleForUid(int p0){ return null; }
    public static UserHandle readFromParcel(Parcel p0){ return null; }
    public static void writeToParcel(UserHandle p0, Parcel p1){}
    public void writeToParcel(Parcel p0, int p1){}
    public static boolean isSameUser(int uid1, int uid2) { return false; }
    public static boolean isSameApp(int uid1, int uid2) { return false; }
    public static boolean isIsolated(int uid) { return false; }
    public static boolean isApp(int uid) { return false; }
    public static boolean isCore(int uid) { return false; }
    public static int getUserId(int uid) { return 0; }
    public static int getCallingUserId() { return 0; }
    public static int getCallingAppId() { return 0; }
    public static UserHandle of(int userId) { return null; }
    public static int getUid(int userId, int appId) { return 0; }
    public static int getAppId(int uid) { return 0; }
    public static int getUserGid(int userId) { return 0; }
    public static int getSharedAppGid(int uid) { return 0; }
    public static int getSharedAppGid(int userId, int appId) { return 0; }
    public static int getAppIdFromSharedAppGid(int gid) { return 0; }
    public static int getCacheAppGid(int uid) { return 0; }
    public static int getCacheAppGid(int userId, int appId) { return 0; }
    public static void formatUid(StringBuilder sb, int uid) {}
    public static String formatUid(int uid) { return null; }
    public static void formatUid(PrintWriter pw, int uid) {}
    public static int parseUserArg(String arg) { return 0; }
    public static int myUserId() { return 0; }
    public boolean isOwner() { return false; }
    public boolean isSystem() { return false; }
}
