// Generated automatically from android.transition.TransitionPropagation for testing purposes

package android.transition;

import android.transition.Transition;
import android.transition.TransitionValues;
import android.view.ViewGroup;

abstract public class TransitionPropagation
{
    public TransitionPropagation(){}
    public abstract String[] getPropagationProperties();
    public abstract long getStartDelay(ViewGroup p0, Transition p1, TransitionValues p2, TransitionValues p3);
    public abstract void captureValues(TransitionValues p0);
}
