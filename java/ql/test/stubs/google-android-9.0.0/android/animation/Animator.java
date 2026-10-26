// Generated automatically from android.animation.Animator for testing purposes

package android.animation;

import android.animation.TimeInterpolator;
import java.util.ArrayList;

abstract public class Animator implements Cloneable
{
    public Animator clone(){ return null; }
    public Animator(){}
    public ArrayList<Animator.AnimatorListener> getListeners(){ return null; }
    public TimeInterpolator getInterpolator(){ return null; }
    public abstract Animator setDuration(long p0);
    public abstract boolean isRunning();
    public abstract long getDuration();
    public abstract long getStartDelay();
    public abstract void setInterpolator(TimeInterpolator p0);
    public abstract void setStartDelay(long p0);
    public boolean isPaused(){ return false; }
    public boolean isStarted(){ return false; }
    public long getTotalDuration(){ return 0; }
    public static long DURATION_INFINITE = 0;
    public void addListener(Animator.AnimatorListener p0){}
    public void addPauseListener(Animator.AnimatorPauseListener p0){}
    public void cancel(){}
    public void end(){}
    public void pause(){}
    public void removeAllListeners(){}
    public void removeListener(Animator.AnimatorListener p0){}
    public void removePauseListener(Animator.AnimatorPauseListener p0){}
    public void resume(){}
    public void setTarget(Object p0){}
    public void setupEndValues(){}
    public void setupStartValues(){}
    public void start(){}
    static public interface AnimatorListener
    {
        default void onAnimationEnd(Animator p0, boolean p1){}
        default void onAnimationStart(Animator p0, boolean p1){}
        void onAnimationCancel(Animator p0);
        void onAnimationEnd(Animator p0);
        void onAnimationRepeat(Animator p0);
        void onAnimationStart(Animator p0);
    }
    static public interface AnimatorPauseListener
    {
        void onAnimationPause(Animator p0);
        void onAnimationResume(Animator p0);
    }
}
