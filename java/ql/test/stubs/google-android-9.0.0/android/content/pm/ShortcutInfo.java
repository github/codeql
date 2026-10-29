// Generated automatically from android.content.pm.ShortcutInfo for testing purposes

package android.content.pm;

import android.content.ComponentName;
import android.content.Intent;
import android.content.LocusId;
import android.os.Parcel;
import android.os.Parcelable;
import android.os.PersistableBundle;
import android.os.UserHandle;
import java.util.Set;

public class ShortcutInfo implements Parcelable
{
    public CharSequence getDisabledMessage(){ return null; }
    public CharSequence getLongLabel(){ return null; }
    public CharSequence getShortLabel(){ return null; }
    public ComponentName getActivity(){ return null; }
    public Intent getIntent(){ return null; }
    public Intent[] getIntents(){ return null; }
    public LocusId getLocusId(){ return null; }
    public PersistableBundle getExtras(){ return null; }
    public Set<String> getCategories(){ return null; }
    public String getId(){ return null; }
    public String getPackage(){ return null; }
    public String toString(){ return null; }
    public UserHandle getUserHandle(){ return null; }
    public boolean hasKeyFieldsOnly(){ return false; }
    public boolean isCached(){ return false; }
    public boolean isDeclaredInManifest(){ return false; }
    public boolean isDynamic(){ return false; }
    public boolean isEnabled(){ return false; }
    public boolean isImmutable(){ return false; }
    public boolean isPinned(){ return false; }
    public int describeContents(){ return 0; }
    public int getDisabledReason(){ return 0; }
    public int getRank(){ return 0; }
    public long getLastChangedTimestamp(){ return 0; }
    public static Parcelable.Creator<ShortcutInfo> CREATOR = null;
    public static String SHORTCUT_CATEGORY_CONVERSATION = null;
    public static int DISABLED_REASON_APP_CHANGED = 0;
    public static int DISABLED_REASON_BACKUP_NOT_SUPPORTED = 0;
    public static int DISABLED_REASON_BY_APP = 0;
    public static int DISABLED_REASON_NOT_DISABLED = 0;
    public static int DISABLED_REASON_OTHER_RESTORE_ISSUE = 0;
    public static int DISABLED_REASON_SIGNATURE_MISMATCH = 0;
    public static int DISABLED_REASON_UNKNOWN = 0;
    public static int DISABLED_REASON_VERSION_LOWER = 0;
    public void writeToParcel(Parcel p0, int p1){}
}
