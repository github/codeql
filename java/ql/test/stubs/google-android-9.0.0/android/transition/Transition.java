// Generated automatically from android.transition.Transition for testing purposes

package android.transition;

import android.animation.Animator;
import android.animation.TimeInterpolator;
import android.content.Context;
import android.graphics.Rect;
import android.transition.PathMotion;
import android.transition.TransitionPropagation;
import android.transition.TransitionValues;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import java.util.List;

abstract public class Transition implements Cloneable
{
    abstract static public class EpicenterCallback
    {
        public EpicenterCallback(){}
        public abstract Rect onGetEpicenter(Transition p0);
    }
    public Animator createAnimator(ViewGroup p0, TransitionValues p1, TransitionValues p2){ return null; }
    public List<Class> getTargetTypes(){ return null; }
    public List<Integer> getTargetIds(){ return null; }
    public List<String> getTargetNames(){ return null; }
    public List<View> getTargets(){ return null; }
    public PathMotion getPathMotion(){ return null; }
    public Rect getEpicenter(){ return null; }
    public String getName(){ return null; }
    public String toString(){ return null; }
    public String[] getTransitionProperties(){ return null; }
    public TimeInterpolator getInterpolator(){ return null; }
    public Transition addListener(Transition.TransitionListener p0){ return null; }
    public Transition addTarget(Class p0){ return null; }
    public Transition addTarget(String p0){ return null; }
    public Transition addTarget(View p0){ return null; }
    public Transition addTarget(int p0){ return null; }
    public Transition clone(){ return null; }
    public Transition excludeChildren(Class p0, boolean p1){ return null; }
    public Transition excludeChildren(View p0, boolean p1){ return null; }
    public Transition excludeChildren(int p0, boolean p1){ return null; }
    public Transition excludeTarget(Class p0, boolean p1){ return null; }
    public Transition excludeTarget(String p0, boolean p1){ return null; }
    public Transition excludeTarget(View p0, boolean p1){ return null; }
    public Transition excludeTarget(int p0, boolean p1){ return null; }
    public Transition removeListener(Transition.TransitionListener p0){ return null; }
    public Transition removeTarget(Class p0){ return null; }
    public Transition removeTarget(String p0){ return null; }
    public Transition removeTarget(View p0){ return null; }
    public Transition removeTarget(int p0){ return null; }
    public Transition setDuration(long p0){ return null; }
    public Transition setInterpolator(TimeInterpolator p0){ return null; }
    public Transition setStartDelay(long p0){ return null; }
    public Transition(){}
    public Transition(Context p0, AttributeSet p1){}
    public Transition.EpicenterCallback getEpicenterCallback(){ return null; }
    public TransitionPropagation getPropagation(){ return null; }
    public TransitionValues getTransitionValues(View p0, boolean p1){ return null; }
    public abstract void captureEndValues(TransitionValues p0);
    public abstract void captureStartValues(TransitionValues p0);
    public boolean canRemoveViews(){ return false; }
    public boolean isTransitionRequired(TransitionValues p0, TransitionValues p1){ return false; }
    public long getDuration(){ return 0; }
    public long getStartDelay(){ return 0; }
    public static int MATCH_ID = 0;
    public static int MATCH_INSTANCE = 0;
    public static int MATCH_ITEM_ID = 0;
    public static int MATCH_NAME = 0;
    public void setEpicenterCallback(Transition.EpicenterCallback p0){}
    public void setMatchOrder(int... p0){}
    public void setPathMotion(PathMotion p0){}
    public void setPropagation(TransitionPropagation p0){}
    static public interface TransitionListener
    {
        void onTransitionCancel(Transition p0);
        void onTransitionEnd(Transition p0);
        void onTransitionPause(Transition p0);
        void onTransitionResume(Transition p0);
        void onTransitionStart(Transition p0);
    }
}
