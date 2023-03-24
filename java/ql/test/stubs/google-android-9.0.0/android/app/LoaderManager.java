// Generated automatically from android.app.LoaderManager for testing purposes

package android.app;

import android.content.Loader;
import android.os.Bundle;
import java.io.FileDescriptor;
import java.io.PrintWriter;

abstract public class LoaderManager
{
    public LoaderManager(){}
    public abstract <D> Loader<D> getLoader(int p0);
    public abstract <D> Loader<D> initLoader(int p0, Bundle p1, LoaderManager.LoaderCallbacks<D> p2);
    public abstract <D> Loader<D> restartLoader(int p0, Bundle p1, LoaderManager.LoaderCallbacks<D> p2);
    public abstract void destroyLoader(int p0);
    public abstract void dump(String p0, FileDescriptor p1, PrintWriter p2, String[] p3);
    public static void enableDebugLogging(boolean p0){}
    static public interface LoaderCallbacks<D>
    {
        Loader<D> onCreateLoader(int p0, Bundle p1);
        void onLoadFinished(Loader<D> p0, D p1);
        void onLoaderReset(Loader<D> p0);
    }
}
