// Generated automatically from android.view.animation.Animation for testing purposes

package android.view.animation;

import android.content.Context;
import android.util.AttributeSet;
import android.view.animation.Interpolator;
import android.view.animation.Transformation;

abstract public class Animation implements Cloneable
{
    protected Animation clone(){ return null; }
    protected float getScaleFactor(){ return 0; }
    protected float resolveSize(int p0, float p1, int p2, int p3){ return 0; }
    protected void applyTransformation(float p0, Transformation p1){}
    protected void ensureInterpolator(){}
    protected void finalize(){}
    public Animation(){}
    public Animation(Context p0, AttributeSet p1){}
    public Interpolator getInterpolator(){ return null; }
    public boolean getDetachWallpaper(){ return false; }
    public boolean getFillAfter(){ return false; }
    public boolean getFillBefore(){ return false; }
    public boolean getTransformation(long p0, Transformation p1){ return false; }
    public boolean getTransformation(long p0, Transformation p1, float p2){ return false; }
    public boolean hasEnded(){ return false; }
    public boolean hasStarted(){ return false; }
    public boolean isFillEnabled(){ return false; }
    public boolean isInitialized(){ return false; }
    public boolean willChangeBounds(){ return false; }
    public boolean willChangeTransformationMatrix(){ return false; }
    public int getBackgroundColor(){ return 0; }
    public int getRepeatCount(){ return 0; }
    public int getRepeatMode(){ return 0; }
    public int getZAdjustment(){ return 0; }
    public long computeDurationHint(){ return 0; }
    public long getDuration(){ return 0; }
    public long getStartOffset(){ return 0; }
    public long getStartTime(){ return 0; }
    public static int ABSOLUTE = 0;
    public static int INFINITE = 0;
    public static int RELATIVE_TO_PARENT = 0;
    public static int RELATIVE_TO_SELF = 0;
    public static int RESTART = 0;
    public static int REVERSE = 0;
    public static int START_ON_FIRST_FRAME = 0;
    public static int ZORDER_BOTTOM = 0;
    public static int ZORDER_NORMAL = 0;
    public static int ZORDER_TOP = 0;
    public void cancel(){}
    public void initialize(int p0, int p1, int p2, int p3){}
    public void reset(){}
    public void restrictDuration(long p0){}
    public void scaleCurrentDuration(float p0){}
    public void setAnimationListener(Animation.AnimationListener p0){}
    public void setBackgroundColor(int p0){}
    public void setDetachWallpaper(boolean p0){}
    public void setDuration(long p0){}
    public void setFillAfter(boolean p0){}
    public void setFillBefore(boolean p0){}
    public void setFillEnabled(boolean p0){}
    public void setInterpolator(Context p0, int p1){}
    public void setInterpolator(Interpolator p0){}
    public void setRepeatCount(int p0){}
    public void setRepeatMode(int p0){}
    public void setStartOffset(long p0){}
    public void setStartTime(long p0){}
    public void setZAdjustment(int p0){}
    public void start(){}
    public void startNow(){}
    static public interface AnimationListener
    {
        void onAnimationEnd(Animation p0);
        void onAnimationRepeat(Animation p0);
        void onAnimationStart(Animation p0);
    }
}
