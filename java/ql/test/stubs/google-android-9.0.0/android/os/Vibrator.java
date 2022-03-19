// Generated automatically from android.os.Vibrator for testing purposes

package android.os;

import android.media.AudioAttributes;
import android.os.VibrationEffect;

abstract public class Vibrator
{
    public abstract boolean hasAmplitudeControl();
    public abstract boolean hasVibrator();
    public abstract void cancel();
    public boolean[] arePrimitivesSupported(int... p0){ return null; }
    public final boolean areAllPrimitivesSupported(int... p0){ return false; }
    public final int areAllEffectsSupported(int... p0){ return 0; }
    public int getId(){ return 0; }
    public int[] areEffectsSupported(int... p0){ return null; }
    public int[] getPrimitiveDurations(int... p0){ return null; }
    public static int VIBRATION_EFFECT_SUPPORT_NO = 0;
    public static int VIBRATION_EFFECT_SUPPORT_UNKNOWN = 0;
    public static int VIBRATION_EFFECT_SUPPORT_YES = 0;
    public void vibrate(VibrationEffect p0){}
    public void vibrate(VibrationEffect p0, AudioAttributes p1){}
    public void vibrate(long p0){}
    public void vibrate(long p0, AudioAttributes p1){}
    public void vibrate(long[] p0, int p1){}
    public void vibrate(long[] p0, int p1, AudioAttributes p2){}
}
