// Generated automatically from android.animation.LayoutTransition for testing purposes

package android.animation;

import android.animation.Animator;
import android.animation.TimeInterpolator;
import android.view.View;
import android.view.ViewGroup;
import java.util.List;

public class LayoutTransition
{
    public Animator getAnimator(int p0){ return null; }
    public LayoutTransition(){}
    public List<LayoutTransition.TransitionListener> getTransitionListeners(){ return null; }
    public TimeInterpolator getInterpolator(int p0){ return null; }
    public boolean isChangingLayout(){ return false; }
    public boolean isRunning(){ return false; }
    public boolean isTransitionTypeEnabled(int p0){ return false; }
    public long getDuration(int p0){ return 0; }
    public long getStagger(int p0){ return 0; }
    public long getStartDelay(int p0){ return 0; }
    public static int APPEARING = 0;
    public static int CHANGE_APPEARING = 0;
    public static int CHANGE_DISAPPEARING = 0;
    public static int CHANGING = 0;
    public static int DISAPPEARING = 0;
    public void addChild(ViewGroup p0, View p1){}
    public void addTransitionListener(LayoutTransition.TransitionListener p0){}
    public void disableTransitionType(int p0){}
    public void enableTransitionType(int p0){}
    public void hideChild(ViewGroup p0, View p1){}
    public void hideChild(ViewGroup p0, View p1, int p2){}
    public void removeChild(ViewGroup p0, View p1){}
    public void removeTransitionListener(LayoutTransition.TransitionListener p0){}
    public void setAnimateParentHierarchy(boolean p0){}
    public void setAnimator(int p0, Animator p1){}
    public void setDuration(int p0, long p1){}
    public void setDuration(long p0){}
    public void setInterpolator(int p0, TimeInterpolator p1){}
    public void setStagger(int p0, long p1){}
    public void setStartDelay(int p0, long p1){}
    public void showChild(ViewGroup p0, View p1){}
    public void showChild(ViewGroup p0, View p1, int p2){}
    static public interface TransitionListener
    {
        void endTransition(LayoutTransition p0, ViewGroup p1, View p2, int p3);
        void startTransition(LayoutTransition p0, ViewGroup p1, View p2, int p3);
    }
}
