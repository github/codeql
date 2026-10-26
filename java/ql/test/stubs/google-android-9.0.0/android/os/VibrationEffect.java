// Generated automatically from android.os.VibrationEffect for testing purposes

package android.os;

import android.os.Parcelable;

abstract public class VibrationEffect implements Parcelable
{
    public int describeContents(){ return 0; }
    public static Parcelable.Creator<VibrationEffect> CREATOR = null;
    public static VibrationEffect createOneShot(long p0, int p1){ return null; }
    public static VibrationEffect createPredefined(int p0){ return null; }
    public static VibrationEffect createWaveform(long[] p0, int p1){ return null; }
    public static VibrationEffect createWaveform(long[] p0, int[] p1, int p2){ return null; }
    public static VibrationEffect.Composition startComposition(){ return null; }
    public static int DEFAULT_AMPLITUDE = 0;
    public static int EFFECT_CLICK = 0;
    public static int EFFECT_DOUBLE_CLICK = 0;
    public static int EFFECT_HEAVY_CLICK = 0;
    public static int EFFECT_TICK = 0;
    static public class Composition
    {
        public VibrationEffect compose(){ return null; }
        public VibrationEffect.Composition addPrimitive(int p0){ return null; }
        public VibrationEffect.Composition addPrimitive(int p0, float p1){ return null; }
        public VibrationEffect.Composition addPrimitive(int p0, float p1, int p2){ return null; }
        public static int PRIMITIVE_CLICK = 0;
        public static int PRIMITIVE_LOW_TICK = 0;
        public static int PRIMITIVE_QUICK_FALL = 0;
        public static int PRIMITIVE_QUICK_RISE = 0;
        public static int PRIMITIVE_SLOW_RISE = 0;
        public static int PRIMITIVE_SPIN = 0;
        public static int PRIMITIVE_THUD = 0;
        public static int PRIMITIVE_TICK = 0;
    }
}
