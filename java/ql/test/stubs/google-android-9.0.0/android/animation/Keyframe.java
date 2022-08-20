// Generated automatically from android.animation.Keyframe for testing purposes

package android.animation;

import android.animation.TimeInterpolator;

abstract public class Keyframe implements Cloneable
{
    public Class getType(){ return null; }
    public Keyframe(){}
    public TimeInterpolator getInterpolator(){ return null; }
    public abstract Keyframe clone();
    public abstract Object getValue();
    public abstract void setValue(Object p0);
    public boolean hasValue(){ return false; }
    public float getFraction(){ return 0; }
    public static Keyframe ofFloat(float p0){ return null; }
    public static Keyframe ofFloat(float p0, float p1){ return null; }
    public static Keyframe ofInt(float p0){ return null; }
    public static Keyframe ofInt(float p0, int p1){ return null; }
    public static Keyframe ofObject(float p0){ return null; }
    public static Keyframe ofObject(float p0, Object p1){ return null; }
    public void setFraction(float p0){}
    public void setInterpolator(TimeInterpolator p0){}
}
