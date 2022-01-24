// Generated automatically from android.view.ViewTreeObserver for testing purposes

package android.view;

import android.graphics.Rect;
import android.view.View;
import java.util.List;
import java.util.function.Consumer;

public class ViewTreeObserver
{
    public boolean dispatchOnPreDraw(){ return false; }
    public boolean isAlive(){ return false; }
    public boolean unregisterFrameCommitCallback(Runnable p0){ return false; }
    public void addOnDrawListener(ViewTreeObserver.OnDrawListener p0){}
    public void addOnGlobalFocusChangeListener(ViewTreeObserver.OnGlobalFocusChangeListener p0){}
    public void addOnGlobalLayoutListener(ViewTreeObserver.OnGlobalLayoutListener p0){}
    public void addOnPreDrawListener(ViewTreeObserver.OnPreDrawListener p0){}
    public void addOnScrollChangedListener(ViewTreeObserver.OnScrollChangedListener p0){}
    public void addOnSystemGestureExclusionRectsChangedListener(Consumer<List<Rect>> p0){}
    public void addOnTouchModeChangeListener(ViewTreeObserver.OnTouchModeChangeListener p0){}
    public void addOnWindowAttachListener(ViewTreeObserver.OnWindowAttachListener p0){}
    public void addOnWindowFocusChangeListener(ViewTreeObserver.OnWindowFocusChangeListener p0){}
    public void dispatchOnDraw(){}
    public void dispatchOnGlobalLayout(){}
    public void registerFrameCommitCallback(Runnable p0){}
    public void removeGlobalOnLayoutListener(ViewTreeObserver.OnGlobalLayoutListener p0){}
    public void removeOnDrawListener(ViewTreeObserver.OnDrawListener p0){}
    public void removeOnGlobalFocusChangeListener(ViewTreeObserver.OnGlobalFocusChangeListener p0){}
    public void removeOnGlobalLayoutListener(ViewTreeObserver.OnGlobalLayoutListener p0){}
    public void removeOnPreDrawListener(ViewTreeObserver.OnPreDrawListener p0){}
    public void removeOnScrollChangedListener(ViewTreeObserver.OnScrollChangedListener p0){}
    public void removeOnSystemGestureExclusionRectsChangedListener(Consumer<List<Rect>> p0){}
    public void removeOnTouchModeChangeListener(ViewTreeObserver.OnTouchModeChangeListener p0){}
    public void removeOnWindowAttachListener(ViewTreeObserver.OnWindowAttachListener p0){}
    public void removeOnWindowFocusChangeListener(ViewTreeObserver.OnWindowFocusChangeListener p0){}
    static public interface OnDrawListener
    {
        void onDraw();
    }
    static public interface OnGlobalFocusChangeListener
    {
        void onGlobalFocusChanged(View p0, View p1);
    }
    static public interface OnGlobalLayoutListener
    {
        void onGlobalLayout();
    }
    static public interface OnPreDrawListener
    {
        boolean onPreDraw();
    }
    static public interface OnScrollChangedListener
    {
        void onScrollChanged();
    }
    static public interface OnTouchModeChangeListener
    {
        void onTouchModeChanged(boolean p0);
    }
    static public interface OnWindowAttachListener
    {
        void onWindowAttached();
        void onWindowDetached();
    }
    static public interface OnWindowFocusChangeListener
    {
        void onWindowFocusChanged(boolean p0);
    }
}
