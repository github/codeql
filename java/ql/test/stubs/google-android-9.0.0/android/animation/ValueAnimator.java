// Generated automatically from android.animation.ValueAnimator for testing purposes

package android.animation;

import android.animation.Animator;
import android.animation.PropertyValuesHolder;
import android.animation.TimeInterpolator;
import android.animation.TypeEvaluator;

public class ValueAnimator extends Animator
{
    public Object getAnimatedValue(){ return null; }
    public Object getAnimatedValue(String p0){ return null; }
    public PropertyValuesHolder[] getValues(){ return null; }
    public String toString(){ return null; }
    public TimeInterpolator getInterpolator(){ return null; }
    public ValueAnimator clone(){ return null; }
    public ValueAnimator setDuration(long p0){ return null; }
    public ValueAnimator(){}
    public boolean isRunning(){ return false; }
    public boolean isStarted(){ return false; }
    public float getAnimatedFraction(){ return 0; }
    public int getRepeatCount(){ return 0; }
    public int getRepeatMode(){ return 0; }
    public long getCurrentPlayTime(){ return 0; }
    public long getDuration(){ return 0; }
    public long getStartDelay(){ return 0; }
    public long getTotalDuration(){ return 0; }
    public static ValueAnimator ofArgb(int... p0){ return null; }
    public static ValueAnimator ofFloat(float... p0){ return null; }
    public static ValueAnimator ofInt(int... p0){ return null; }
    public static ValueAnimator ofObject(TypeEvaluator p0, Object... p1){ return null; }
    public static ValueAnimator ofPropertyValuesHolder(PropertyValuesHolder... p0){ return null; }
    public static boolean areAnimatorsEnabled(){ return false; }
    public static int INFINITE = 0;
    public static int RESTART = 0;
    public static int REVERSE = 0;
    public static long getFrameDelay(){ return 0; }
    public static void setFrameDelay(long p0){}
    public void addUpdateListener(ValueAnimator.AnimatorUpdateListener p0){}
    public void cancel(){}
    public void end(){}
    public void pause(){}
    public void removeAllUpdateListeners(){}
    public void removeUpdateListener(ValueAnimator.AnimatorUpdateListener p0){}
    public void resume(){}
    public void reverse(){}
    public void setCurrentFraction(float p0){}
    public void setCurrentPlayTime(long p0){}
    public void setEvaluator(TypeEvaluator p0){}
    public void setFloatValues(float... p0){}
    public void setIntValues(int... p0){}
    public void setInterpolator(TimeInterpolator p0){}
    public void setObjectValues(Object... p0){}
    public void setRepeatCount(int p0){}
    public void setRepeatMode(int p0){}
    public void setStartDelay(long p0){}
    public void setValues(PropertyValuesHolder... p0){}
    public void start(){}
    static public interface AnimatorUpdateListener
    {
        void onAnimationUpdate(ValueAnimator p0);
    }
}
