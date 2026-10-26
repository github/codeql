// Generated automatically from android.view.AttachedSurfaceControl for testing purposes

package android.view;

import android.view.SurfaceControl;

public interface AttachedSurfaceControl
{
    SurfaceControl.Transaction buildReparentTransaction(SurfaceControl p0);
    boolean applyTransactionOnDraw(SurfaceControl.Transaction p0);
    default int getBufferTransformHint(){ return 0; }
    default void addOnBufferTransformHintChangedListener(AttachedSurfaceControl.OnBufferTransformHintChangedListener p0){}
    default void removeOnBufferTransformHintChangedListener(AttachedSurfaceControl.OnBufferTransformHintChangedListener p0){}
    static public interface OnBufferTransformHintChangedListener
    {
        void onBufferTransformHintChanged(int p0);
    }
}
