// Generated automatically from android.content.ContentResolver for testing purposes

package android.content;

import android.accounts.Account;
import android.content.ContentProvider;
import android.content.ContentProviderClient;
import android.content.ContentProviderOperation;
import android.content.ContentProviderResult;
import android.content.ContentValues;
import android.content.Context;
import android.content.PeriodicSync;
import android.content.SyncAdapterType;
import android.content.SyncInfo;
import android.content.SyncRequest;
import android.content.SyncStatusObserver;
import android.content.UriPermission;
import android.content.res.AssetFileDescriptor;
import android.database.ContentObserver;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.drawable.Icon;
import android.net.Uri;
import android.os.Bundle;
import android.os.CancellationSignal;
import android.os.ParcelFileDescriptor;
import android.util.Size;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

abstract public class ContentResolver
{
    protected ContentResolver() {}
    public Bitmap loadThumbnail(Uri p0, Size p1, CancellationSignal p2){ return null; }
    public ContentProviderResult[] applyBatch(String p0, ArrayList<ContentProviderOperation> p1){ return null; }
    public ContentResolver(Context p0){}
    public List<UriPermission> getOutgoingPersistedUriPermissions(){ return null; }
    public List<UriPermission> getPersistedUriPermissions(){ return null; }
    public String[] getStreamTypes(Uri p0, String p1){ return null; }
    public final AssetFileDescriptor openAssetFile(Uri p0, String p1, CancellationSignal p2){ return null; }
    public final AssetFileDescriptor openAssetFileDescriptor(Uri p0, String p1){ return null; }
    public final AssetFileDescriptor openAssetFileDescriptor(Uri p0, String p1, CancellationSignal p2){ return null; }
    public final AssetFileDescriptor openTypedAssetFile(Uri p0, String p1, Bundle p2, CancellationSignal p3){ return null; }
    public final AssetFileDescriptor openTypedAssetFileDescriptor(Uri p0, String p1, Bundle p2){ return null; }
    public final AssetFileDescriptor openTypedAssetFileDescriptor(Uri p0, String p1, Bundle p2, CancellationSignal p3){ return null; }
    public final Bundle call(String p0, String p1, String p2, Bundle p3){ return null; }
    public final Bundle call(Uri p0, String p1, String p2, Bundle p3){ return null; }
    public final ContentProviderClient acquireContentProviderClient(String p0){ return null; }
    public final ContentProviderClient acquireContentProviderClient(Uri p0){ return null; }
    public final ContentProviderClient acquireUnstableContentProviderClient(String p0){ return null; }
    public final ContentProviderClient acquireUnstableContentProviderClient(Uri p0){ return null; }
    public final ContentResolver.MimeTypeInfo getTypeInfo(String p0){ return null; }
    public final Cursor query(Uri p0, String[] p1, Bundle p2, CancellationSignal p3){ return null; }
    public final Cursor query(Uri p0, String[] p1, String p2, String[] p3, String p4){ return null; }
    public final Cursor query(Uri p0, String[] p1, String p2, String[] p3, String p4, CancellationSignal p5){ return null; }
    public final InputStream openInputStream(Uri p0){ return null; }
    public final OutputStream openOutputStream(Uri p0){ return null; }
    public final OutputStream openOutputStream(Uri p0, String p1){ return null; }
    public final ParcelFileDescriptor openFile(Uri p0, String p1, CancellationSignal p2){ return null; }
    public final ParcelFileDescriptor openFileDescriptor(Uri p0, String p1){ return null; }
    public final ParcelFileDescriptor openFileDescriptor(Uri p0, String p1, CancellationSignal p2){ return null; }
    public final String getType(Uri p0){ return null; }
    public final Uri canonicalize(Uri p0){ return null; }
    public final Uri insert(Uri p0, ContentValues p1){ return null; }
    public final Uri insert(Uri p0, ContentValues p1, Bundle p2){ return null; }
    public final Uri uncanonicalize(Uri p0){ return null; }
    public final boolean refresh(Uri p0, Bundle p1, CancellationSignal p2){ return false; }
    public final int bulkInsert(Uri p0, ContentValues[] p1){ return 0; }
    public final int delete(Uri p0, Bundle p1){ return 0; }
    public final int delete(Uri p0, String p1, String[] p2){ return 0; }
    public final int update(Uri p0, ContentValues p1, Bundle p2){ return 0; }
    public final int update(Uri p0, ContentValues p1, String p2, String[] p3){ return 0; }
    public final void registerContentObserver(Uri p0, boolean p1, ContentObserver p2){}
    public final void unregisterContentObserver(ContentObserver p0){}
    public static ContentResolver wrap(ContentProvider p0){ return null; }
    public static ContentResolver wrap(ContentProviderClient p0){ return null; }
    public static List<PeriodicSync> getPeriodicSyncs(Account p0, String p1){ return null; }
    public static List<SyncInfo> getCurrentSyncs(){ return null; }
    public static Object addStatusChangeListener(int p0, SyncStatusObserver p1){ return null; }
    public static String ANY_CURSOR_ITEM_TYPE = null;
    public static String CURSOR_DIR_BASE_TYPE = null;
    public static String CURSOR_ITEM_BASE_TYPE = null;
    public static String EXTRA_HONORED_ARGS = null;
    public static String EXTRA_REFRESH_SUPPORTED = null;
    public static String EXTRA_SIZE = null;
    public static String EXTRA_TOTAL_COUNT = null;
    public static String QUERY_ARG_GROUP_COLUMNS = null;
    public static String QUERY_ARG_LIMIT = null;
    public static String QUERY_ARG_OFFSET = null;
    public static String QUERY_ARG_SORT_COLLATION = null;
    public static String QUERY_ARG_SORT_COLUMNS = null;
    public static String QUERY_ARG_SORT_DIRECTION = null;
    public static String QUERY_ARG_SORT_LOCALE = null;
    public static String QUERY_ARG_SQL_GROUP_BY = null;
    public static String QUERY_ARG_SQL_HAVING = null;
    public static String QUERY_ARG_SQL_LIMIT = null;
    public static String QUERY_ARG_SQL_SELECTION = null;
    public static String QUERY_ARG_SQL_SELECTION_ARGS = null;
    public static String QUERY_ARG_SQL_SORT_ORDER = null;
    public static String SCHEME_ANDROID_RESOURCE = null;
    public static String SCHEME_CONTENT = null;
    public static String SCHEME_FILE = null;
    public static String SYNC_EXTRAS_ACCOUNT = null;
    public static String SYNC_EXTRAS_DISCARD_LOCAL_DELETIONS = null;
    public static String SYNC_EXTRAS_DO_NOT_RETRY = null;
    public static String SYNC_EXTRAS_EXPEDITED = null;
    public static String SYNC_EXTRAS_FORCE = null;
    public static String SYNC_EXTRAS_IGNORE_BACKOFF = null;
    public static String SYNC_EXTRAS_IGNORE_SETTINGS = null;
    public static String SYNC_EXTRAS_INITIALIZE = null;
    public static String SYNC_EXTRAS_MANUAL = null;
    public static String SYNC_EXTRAS_OVERRIDE_TOO_MANY_DELETIONS = null;
    public static String SYNC_EXTRAS_REQUIRE_CHARGING = null;
    public static String SYNC_EXTRAS_SCHEDULE_AS_EXPEDITED_JOB = null;
    public static String SYNC_EXTRAS_UPLOAD = null;
    public static SyncAdapterType[] getSyncAdapterTypes(){ return null; }
    public static SyncInfo getCurrentSync(){ return null; }
    public static boolean getMasterSyncAutomatically(){ return false; }
    public static boolean getSyncAutomatically(Account p0, String p1){ return false; }
    public static boolean isSyncActive(Account p0, String p1){ return false; }
    public static boolean isSyncPending(Account p0, String p1){ return false; }
    public static int NOTIFY_DELETE = 0;
    public static int NOTIFY_INSERT = 0;
    public static int NOTIFY_SKIP_NOTIFY_FOR_DESCENDANTS = 0;
    public static int NOTIFY_SYNC_TO_NETWORK = 0;
    public static int NOTIFY_UPDATE = 0;
    public static int QUERY_SORT_DIRECTION_ASCENDING = 0;
    public static int QUERY_SORT_DIRECTION_DESCENDING = 0;
    public static int SYNC_OBSERVER_TYPE_ACTIVE = 0;
    public static int SYNC_OBSERVER_TYPE_PENDING = 0;
    public static int SYNC_OBSERVER_TYPE_SETTINGS = 0;
    public static int getIsSyncable(Account p0, String p1){ return 0; }
    public static void addPeriodicSync(Account p0, String p1, Bundle p2, long p3){}
    public static void cancelSync(Account p0, String p1){}
    public static void cancelSync(SyncRequest p0){}
    public static void removePeriodicSync(Account p0, String p1, Bundle p2){}
    public static void removeStatusChangeListener(Object p0){}
    public static void requestSync(Account p0, String p1, Bundle p2){}
    public static void requestSync(SyncRequest p0){}
    public static void setIsSyncable(Account p0, String p1, int p2){}
    public static void setMasterSyncAutomatically(boolean p0){}
    public static void setSyncAutomatically(Account p0, String p1, boolean p2){}
    public static void validateSyncExtrasBundle(Bundle p0){}
    public void cancelSync(Uri p0){}
    public void notifyChange(Collection<Uri> p0, ContentObserver p1, int p2){}
    public void notifyChange(Uri p0, ContentObserver p1){}
    public void notifyChange(Uri p0, ContentObserver p1, boolean p2){}
    public void notifyChange(Uri p0, ContentObserver p1, int p2){}
    public void releasePersistableUriPermission(Uri p0, int p1){}
    public void startSync(Uri p0, Bundle p1){}
    public void takePersistableUriPermission(Uri p0, int p1){}
    static public class MimeTypeInfo
    {
        public CharSequence getContentDescription(){ return null; }
        public CharSequence getLabel(){ return null; }
        public Icon getIcon(){ return null; }
    }
}
