// Generated automatically from android.content.res.loader.ResourcesProvider for testing purposes

package android.content.res.loader;

import android.content.Context;
import android.content.res.loader.AssetsProvider;
import android.os.ParcelFileDescriptor;
import java.io.Closeable;

public class ResourcesProvider implements AutoCloseable, Closeable
{
    protected ResourcesProvider() {}
    protected void finalize(){}
    public static ResourcesProvider empty(AssetsProvider p0){ return null; }
    public static ResourcesProvider loadFromApk(ParcelFileDescriptor p0){ return null; }
    public static ResourcesProvider loadFromApk(ParcelFileDescriptor p0, AssetsProvider p1){ return null; }
    public static ResourcesProvider loadFromDirectory(String p0, AssetsProvider p1){ return null; }
    public static ResourcesProvider loadFromSplit(Context p0, String p1){ return null; }
    public static ResourcesProvider loadFromTable(ParcelFileDescriptor p0, AssetsProvider p1){ return null; }
    public void close(){}
}
