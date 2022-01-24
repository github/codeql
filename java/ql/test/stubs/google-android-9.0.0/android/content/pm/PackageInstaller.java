// Generated automatically from android.content.pm.PackageInstaller for testing purposes

package android.content.pm;

import android.content.Intent;
import android.content.IntentSender;
import android.content.pm.Checksum;
import android.content.pm.VersionedPackage;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Handler;
import android.os.Parcel;
import android.os.Parcelable;
import android.os.UserHandle;
import java.io.Closeable;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;
import java.util.Set;

public class PackageInstaller
{
    abstract static public class SessionCallback
    {
        public SessionCallback(){}
        public abstract void onActiveChanged(int p0, boolean p1);
        public abstract void onBadgingChanged(int p0);
        public abstract void onCreated(int p0);
        public abstract void onFinished(int p0, boolean p1);
        public abstract void onProgressChanged(int p0, float p1);
    }
    public List<PackageInstaller.SessionInfo> getActiveStagedSessions(){ return null; }
    public List<PackageInstaller.SessionInfo> getAllSessions(){ return null; }
    public List<PackageInstaller.SessionInfo> getMySessions(){ return null; }
    public List<PackageInstaller.SessionInfo> getStagedSessions(){ return null; }
    public PackageInstaller.Session openSession(int p0){ return null; }
    public PackageInstaller.SessionInfo getActiveStagedSession(){ return null; }
    public PackageInstaller.SessionInfo getSessionInfo(int p0){ return null; }
    public int createSession(PackageInstaller.SessionParams p0){ return 0; }
    public static String ACTION_SESSION_COMMITTED = null;
    public static String ACTION_SESSION_DETAILS = null;
    public static String ACTION_SESSION_UPDATED = null;
    public static String EXTRA_OTHER_PACKAGE_NAME = null;
    public static String EXTRA_PACKAGE_NAME = null;
    public static String EXTRA_SESSION = null;
    public static String EXTRA_SESSION_ID = null;
    public static String EXTRA_STATUS = null;
    public static String EXTRA_STATUS_MESSAGE = null;
    public static String EXTRA_STORAGE_PATH = null;
    public static int STATUS_FAILURE = 0;
    public static int STATUS_FAILURE_ABORTED = 0;
    public static int STATUS_FAILURE_BLOCKED = 0;
    public static int STATUS_FAILURE_CONFLICT = 0;
    public static int STATUS_FAILURE_INCOMPATIBLE = 0;
    public static int STATUS_FAILURE_INVALID = 0;
    public static int STATUS_FAILURE_STORAGE = 0;
    public static int STATUS_PENDING_USER_ACTION = 0;
    public static int STATUS_SUCCESS = 0;
    public void abandonSession(int p0){}
    public void installExistingPackage(String p0, int p1, IntentSender p2){}
    public void registerSessionCallback(PackageInstaller.SessionCallback p0){}
    public void registerSessionCallback(PackageInstaller.SessionCallback p0, Handler p1){}
    public void uninstall(String p0, IntentSender p1){}
    public void uninstall(VersionedPackage p0, IntentSender p1){}
    public void uninstallExistingPackage(String p0, IntentSender p1){}
    public void unregisterSessionCallback(PackageInstaller.SessionCallback p0){}
    public void updateSessionAppIcon(int p0, Bitmap p1){}
    public void updateSessionAppLabel(int p0, CharSequence p1){}
    static public class Session implements Closeable
    {
        public InputStream openRead(String p0){ return null; }
        public OutputStream openWrite(String p0, long p1, long p2){ return null; }
        public String[] getNames(){ return null; }
        public boolean isMultiPackage(){ return false; }
        public boolean isStaged(){ return false; }
        public int getParentSessionId(){ return 0; }
        public int[] getChildSessionIds(){ return null; }
        public void abandon(){}
        public void addChildSessionId(int p0){}
        public void close(){}
        public void commit(IntentSender p0){}
        public void fsync(OutputStream p0){}
        public void removeChildSessionId(int p0){}
        public void removeSplit(String p0){}
        public void setChecksums(String p0, List<Checksum> p1, byte[] p2){}
        public void setStagingProgress(float p0){}
        public void transfer(String p0){}
    }
    static public class SessionInfo implements Parcelable
    {
        public Bitmap getAppIcon(){ return null; }
        public CharSequence getAppLabel(){ return null; }
        public Intent createDetailsIntent(){ return null; }
        public String getAppPackageName(){ return null; }
        public String getInstallerAttributionTag(){ return null; }
        public String getInstallerPackageName(){ return null; }
        public String getStagedSessionErrorMessage(){ return null; }
        public Uri getOriginatingUri(){ return null; }
        public Uri getReferrerUri(){ return null; }
        public UserHandle getUser(){ return null; }
        public boolean hasParentSessionId(){ return false; }
        public boolean isActive(){ return false; }
        public boolean isCommitted(){ return false; }
        public boolean isMultiPackage(){ return false; }
        public boolean isSealed(){ return false; }
        public boolean isStaged(){ return false; }
        public boolean isStagedSessionActive(){ return false; }
        public boolean isStagedSessionApplied(){ return false; }
        public boolean isStagedSessionFailed(){ return false; }
        public boolean isStagedSessionReady(){ return false; }
        public float getProgress(){ return 0; }
        public int describeContents(){ return 0; }
        public int getInstallLocation(){ return 0; }
        public int getInstallReason(){ return 0; }
        public int getMode(){ return 0; }
        public int getOriginatingUid(){ return 0; }
        public int getParentSessionId(){ return 0; }
        public int getRequireUserAction(){ return 0; }
        public int getSessionId(){ return 0; }
        public int getStagedSessionErrorCode(){ return 0; }
        public int[] getChildSessionIds(){ return null; }
        public long getCreatedMillis(){ return 0; }
        public long getSize(){ return 0; }
        public long getUpdatedMillis(){ return 0; }
        public static Parcelable.Creator<PackageInstaller.SessionInfo> CREATOR = null;
        public static int INVALID_ID = 0;
        public static int STAGED_SESSION_ACTIVATION_FAILED = 0;
        public static int STAGED_SESSION_CONFLICT = 0;
        public static int STAGED_SESSION_NO_ERROR = 0;
        public static int STAGED_SESSION_UNKNOWN = 0;
        public static int STAGED_SESSION_VERIFICATION_FAILED = 0;
        public void writeToParcel(Parcel p0, int p1){}
    }
    static public class SessionParams implements Parcelable
    {
        protected SessionParams() {}
        public SessionParams(int p0){}
        public int describeContents(){ return 0; }
        public static Parcelable.Creator<PackageInstaller.SessionParams> CREATOR = null;
        public static Set<String> RESTRICTED_PERMISSIONS_ALL = null;
        public static int MODE_FULL_INSTALL = 0;
        public static int MODE_INHERIT_EXISTING = 0;
        public static int USER_ACTION_NOT_REQUIRED = 0;
        public static int USER_ACTION_REQUIRED = 0;
        public static int USER_ACTION_UNSPECIFIED = 0;
        public void setAppIcon(Bitmap p0){}
        public void setAppLabel(CharSequence p0){}
        public void setAppPackageName(String p0){}
        public void setAutoRevokePermissionsMode(boolean p0){}
        public void setInstallLocation(int p0){}
        public void setInstallReason(int p0){}
        public void setInstallScenario(int p0){}
        public void setMultiPackage(){}
        public void setOriginatingUid(int p0){}
        public void setOriginatingUri(Uri p0){}
        public void setReferrerUri(Uri p0){}
        public void setRequireUserAction(int p0){}
        public void setSize(long p0){}
        public void setWhitelistedRestrictedPermissions(Set<String> p0){}
        public void writeToParcel(Parcel p0, int p1){}
    }
}
