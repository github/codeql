// Generated automatically from android.app.SharedElementCallback for testing purposes

package android.app;

import android.content.Context;
import android.graphics.Matrix;
import android.graphics.RectF;
import android.os.Parcelable;
import android.view.View;
import java.util.List;
import java.util.Map;

abstract public class SharedElementCallback
{
    public Parcelable onCaptureSharedElementSnapshot(View p0, Matrix p1, RectF p2){ return null; }
    public SharedElementCallback(){}
    public View onCreateSnapshotView(Context p0, Parcelable p1){ return null; }
    public void onMapSharedElements(List<String> p0, Map<String, View> p1){}
    public void onRejectSharedElements(List<View> p0){}
    public void onSharedElementEnd(List<String> p0, List<View> p1, List<View> p2){}
    public void onSharedElementStart(List<String> p0, List<View> p1, List<View> p2){}
    public void onSharedElementsArrived(List<String> p0, List<View> p1, SharedElementCallback.OnSharedElementsReadyListener p2){}
    static public interface OnSharedElementsReadyListener
    {
        void onSharedElementsReady();
    }
}
