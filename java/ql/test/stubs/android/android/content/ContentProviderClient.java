// Generated automatically from android.content.ContentProviderClient for testing purposes

package android.content;

import android.content.ContentProvider;
import android.content.ContentProviderOperation;
import android.content.ContentProviderResult;
import android.content.ContentValues;
import android.content.res.AssetFileDescriptor;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.os.CancellationSignal;
import android.os.ParcelFileDescriptor;
import java.util.ArrayList;

public class ContentProviderClient implements AutoCloseable
{
    protected void finalize(){}
    public AssetFileDescriptor openAssetFile(Uri p0, String p1){ return null; }
    public AssetFileDescriptor openAssetFile(Uri p0, String p1, CancellationSignal p2){ return null; }
    public Bundle call(String p0, String p1, Bundle p2){ return null; }
    public Bundle call(String p0, String p1, String p2, Bundle p3){ return null; }
    public ContentProvider getLocalContentProvider(){ return null; }
    public ContentProviderResult[] applyBatch(ArrayList<ContentProviderOperation> p0){ return null; }
    public ContentProviderResult[] applyBatch(String p0, ArrayList<ContentProviderOperation> p1){ return null; }
    public Cursor query(Uri p0, String[] p1, Bundle p2, CancellationSignal p3){ return null; }
    public Cursor query(Uri p0, String[] p1, String p2, String[] p3, String p4){ return null; }
    public Cursor query(Uri p0, String[] p1, String p2, String[] p3, String p4, CancellationSignal p5){ return null; }
    public ParcelFileDescriptor openFile(Uri p0, String p1){ return null; }
    public ParcelFileDescriptor openFile(Uri p0, String p1, CancellationSignal p2){ return null; }
    public String getType(Uri p0){ return null; }
    public String[] getStreamTypes(Uri p0, String p1){ return null; }
    public Uri insert(Uri p0, ContentValues p1){ return null; }
    public Uri insert(Uri p0, ContentValues p1, Bundle p2){ return null; }
    public boolean refresh(Uri p0, Bundle p1, CancellationSignal p2){ return false; }
    public boolean release(){ return false; }
    public final AssetFileDescriptor openTypedAssetFile(Uri p0, String p1, Bundle p2, CancellationSignal p3){ return null; }
    public final AssetFileDescriptor openTypedAssetFileDescriptor(Uri p0, String p1, Bundle p2){ return null; }
    public final AssetFileDescriptor openTypedAssetFileDescriptor(Uri p0, String p1, Bundle p2, CancellationSignal p3){ return null; }
    public final Uri canonicalize(Uri p0){ return null; }
    public final Uri uncanonicalize(Uri p0){ return null; }
    public int bulkInsert(Uri p0, ContentValues[] p1){ return 0; }
    public int delete(Uri p0, Bundle p1){ return 0; }
    public int delete(Uri p0, String p1, String[] p2){ return 0; }
    public int update(Uri p0, ContentValues p1, Bundle p2){ return 0; }
    public int update(Uri p0, ContentValues p1, String p2, String[] p3){ return 0; }
    public void close(){}
}
