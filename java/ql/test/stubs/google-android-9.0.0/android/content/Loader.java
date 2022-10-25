// Generated automatically from android.content.Loader for testing purposes

package android.content;

import android.content.Context;
import java.io.FileDescriptor;
import java.io.PrintWriter;

public class Loader<D>
{
    protected Loader() {}
    protected boolean onCancelLoad(){ return false; }
    protected void onAbandon(){}
    protected void onForceLoad(){}
    protected void onReset(){}
    protected void onStartLoading(){}
    protected void onStopLoading(){}
    public Context getContext(){ return null; }
    public Loader(Context p0){}
    public String dataToString(D p0){ return null; }
    public String toString(){ return null; }
    public boolean cancelLoad(){ return false; }
    public boolean isAbandoned(){ return false; }
    public boolean isReset(){ return false; }
    public boolean isStarted(){ return false; }
    public boolean takeContentChanged(){ return false; }
    public final void startLoading(){}
    public int getId(){ return 0; }
    public void abandon(){}
    public void commitContentChanged(){}
    public void deliverCancellation(){}
    public void deliverResult(D p0){}
    public void dump(String p0, FileDescriptor p1, PrintWriter p2, String[] p3){}
    public void forceLoad(){}
    public void onContentChanged(){}
    public void registerListener(int p0, Loader.OnLoadCompleteListener<D> p1){}
    public void registerOnLoadCanceledListener(Loader.OnLoadCanceledListener<D> p0){}
    public void reset(){}
    public void rollbackContentChanged(){}
    public void stopLoading(){}
    public void unregisterListener(Loader.OnLoadCompleteListener<D> p0){}
    public void unregisterOnLoadCanceledListener(Loader.OnLoadCanceledListener<D> p0){}
    static public interface OnLoadCanceledListener<D>
    {
        void onLoadCanceled(Loader<D> p0);
    }
    static public interface OnLoadCompleteListener<D>
    {
        void onLoadComplete(Loader<D> p0, D p1);
    }
}
