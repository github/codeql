// Generated automatically from android.graphics.SurfaceTexture for testing purposes

package android.graphics;

import android.os.Handler;

public class SurfaceTexture
{
    protected SurfaceTexture() {}
    protected void finalize(){}
    public SurfaceTexture(boolean p0){}
    public SurfaceTexture(int p0){}
    public SurfaceTexture(int p0, boolean p1){}
    public boolean isReleased(){ return false; }
    public long getTimestamp(){ return 0; }
    public void attachToGLContext(int p0){}
    public void detachFromGLContext(){}
    public void getTransformMatrix(float[] p0){}
    public void release(){}
    public void releaseTexImage(){}
    public void setDefaultBufferSize(int p0, int p1){}
    public void setOnFrameAvailableListener(SurfaceTexture.OnFrameAvailableListener p0){}
    public void setOnFrameAvailableListener(SurfaceTexture.OnFrameAvailableListener p0, Handler p1){}
    public void updateTexImage(){}
    static public interface OnFrameAvailableListener
    {
        void onFrameAvailable(SurfaceTexture p0);
    }
}
