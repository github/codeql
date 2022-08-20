// Generated automatically from android.content.ContentProvider for testing purposes

package android.content;

import android.content.ComponentCallbacks2;
import android.content.ContentProviderOperation;
import android.content.ContentProviderResult;
import android.content.ContentValues;
import android.content.Context;
import android.content.pm.PathPermission;
import android.content.pm.ProviderInfo;
import android.content.res.AssetFileDescriptor;
import android.content.res.Configuration;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.os.CancellationSignal;
import android.os.ParcelFileDescriptor;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;

abstract public class ContentProvider implements ComponentCallbacks2
{
    protected boolean isTemporary(){ return false; }
    protected final ParcelFileDescriptor openFileHelper(Uri p0, String p1){ return null; }
    protected final void setPathPermissions(PathPermission[] p0){}
    protected final void setReadPermission(String p0){}
    protected final void setWritePermission(String p0){}
    public <T> ParcelFileDescriptor openPipeHelper(Uri p0, String p1, Bundle p2, T p3, ContentProvider.PipeDataWriter<T> p4){ return null; }
    public AssetFileDescriptor openAssetFile(Uri p0, String p1){ return null; }
    public AssetFileDescriptor openAssetFile(Uri p0, String p1, CancellationSignal p2){ return null; }
    public AssetFileDescriptor openTypedAssetFile(Uri p0, String p1, Bundle p2){ return null; }
    public AssetFileDescriptor openTypedAssetFile(Uri p0, String p1, Bundle p2, CancellationSignal p3){ return null; }
    public Bundle call(String p0, String p1, Bundle p2){ return null; }
    public Bundle call(String p0, String p1, String p2, Bundle p3){ return null; }
    public ContentProvider(){}
    public ContentProviderResult[] applyBatch(ArrayList<ContentProviderOperation> p0){ return null; }
    public ContentProviderResult[] applyBatch(String p0, ArrayList<ContentProviderOperation> p1){ return null; }
    public Cursor query(Uri p0, String[] p1, Bundle p2, CancellationSignal p3){ return null; }
    public Cursor query(Uri p0, String[] p1, String p2, String[] p3, String p4, CancellationSignal p5){ return null; }
    public ParcelFileDescriptor openFile(Uri p0, String p1){ return null; }
    public ParcelFileDescriptor openFile(Uri p0, String p1, CancellationSignal p2){ return null; }
    public String[] getStreamTypes(Uri p0, String p1){ return null; }
    public Uri canonicalize(Uri p0){ return null; }
    public Uri insert(Uri p0, ContentValues p1, Bundle p2){ return null; }
    public Uri uncanonicalize(Uri p0){ return null; }
    public abstract Cursor query(Uri p0, String[] p1, String p2, String[] p3, String p4);
    public abstract String getType(Uri p0);
    public abstract Uri insert(Uri p0, ContentValues p1);
    public abstract boolean onCreate();
    public abstract int delete(Uri p0, String p1, String[] p2);
    public abstract int update(Uri p0, ContentValues p1, String p2, String[] p3);
    public boolean refresh(Uri p0, Bundle p1, CancellationSignal p2){ return false; }
    public class CallingIdentity
    {
    }
    public final ContentProvider.CallingIdentity clearCallingIdentity(){ return null; }
    public final Context getContext(){ return null; }
    public final Context requireContext(){ return null; }
    public final PathPermission[] getPathPermissions(){ return null; }
    public final String getCallingAttributionTag(){ return null; }
    public final String getCallingPackage(){ return null; }
    public final String getCallingPackageUnchecked(){ return null; }
    public final String getReadPermission(){ return null; }
    public final String getWritePermission(){ return null; }
    public final void restoreCallingIdentity(ContentProvider.CallingIdentity p0){}
    public int bulkInsert(Uri p0, ContentValues[] p1){ return 0; }
    public int delete(Uri p0, Bundle p1){ return 0; }
    public int update(Uri p0, ContentValues p1, Bundle p2){ return 0; }
    public void attachInfo(Context p0, ProviderInfo p1){}
    public void dump(FileDescriptor p0, PrintWriter p1, String[] p2){}
    public void onCallingPackageChanged(){}
    public void onConfigurationChanged(Configuration p0){}
    public void onLowMemory(){}
    public void onTrimMemory(int p0){}
    public void shutdown(){}
    static public interface PipeDataWriter<T>
    {
        void writeDataToPipe(ParcelFileDescriptor p0, Uri p1, String p2, Bundle p3, T p4);
    }
}
