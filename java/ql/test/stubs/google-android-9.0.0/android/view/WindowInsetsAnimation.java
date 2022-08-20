// Generated automatically from android.view.WindowInsetsAnimation for testing purposes

package android.view;

import android.graphics.Insets;
import android.view.WindowInsets;
import android.view.animation.Interpolator;
import java.util.List;

public class WindowInsetsAnimation
{
    protected WindowInsetsAnimation() {}
    abstract static public class Callback
    {
        protected Callback() {}
        public Callback(int p0){}
        public WindowInsetsAnimation.Bounds onStart(WindowInsetsAnimation p0, WindowInsetsAnimation.Bounds p1){ return null; }
        public abstract WindowInsets onProgress(WindowInsets p0, List<WindowInsetsAnimation> p1);
        public final int getDispatchMode(){ return 0; }
        public static int DISPATCH_MODE_CONTINUE_ON_SUBTREE = 0;
        public static int DISPATCH_MODE_STOP = 0;
        public void onEnd(WindowInsetsAnimation p0){}
        public void onPrepare(WindowInsetsAnimation p0){}
    }
    public Interpolator getInterpolator(){ return null; }
    public WindowInsetsAnimation(int p0, Interpolator p1, long p2){}
    public float getAlpha(){ return 0; }
    public float getFraction(){ return 0; }
    public float getInterpolatedFraction(){ return 0; }
    public int getTypeMask(){ return 0; }
    public long getDurationMillis(){ return 0; }
    public void setAlpha(float p0){}
    public void setFraction(float p0){}
    static public class Bounds
    {
        protected Bounds() {}
        public Bounds(Insets p0, Insets p1){}
        public Insets getLowerBound(){ return null; }
        public Insets getUpperBound(){ return null; }
        public String toString(){ return null; }
        public WindowInsetsAnimation.Bounds inset(Insets p0){ return null; }
    }
}
