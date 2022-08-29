// Generated automatically from android.view.SurfaceHolder for testing purposes

package android.view;

import android.graphics.Canvas;
import android.graphics.Rect;
import android.view.Surface;

public interface SurfaceHolder
{
    Canvas lockCanvas();
    Canvas lockCanvas(Rect p0);
    Rect getSurfaceFrame();
    Surface getSurface();
    boolean isCreating();
    default Canvas lockHardwareCanvas(){ return null; }
    static int SURFACE_TYPE_GPU = 0;
    static int SURFACE_TYPE_HARDWARE = 0;
    static int SURFACE_TYPE_NORMAL = 0;
    static int SURFACE_TYPE_PUSH_BUFFERS = 0;
    static public interface Callback
    {
        void surfaceChanged(SurfaceHolder p0, int p1, int p2, int p3);
        void surfaceCreated(SurfaceHolder p0);
        void surfaceDestroyed(SurfaceHolder p0);
    }
    static public interface Callback2 extends SurfaceHolder.Callback
    {
        default void surfaceRedrawNeededAsync(SurfaceHolder p0, Runnable p1){}
        void surfaceRedrawNeeded(SurfaceHolder p0);
    }
    void addCallback(SurfaceHolder.Callback p0);
    void removeCallback(SurfaceHolder.Callback p0);
    void setFixedSize(int p0, int p1);
    void setFormat(int p0);
    void setKeepScreenOn(boolean p0);
    void setSizeFromLayout();
    void setType(int p0);
    void unlockCanvasAndPost(Canvas p0);
}
