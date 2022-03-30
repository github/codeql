// Generated automatically from android.os.VibratorManager for testing purposes

package android.os;

import android.os.CombinedVibration;
import android.os.VibrationAttributes;
import android.os.Vibrator;

abstract public class VibratorManager
{
    public abstract Vibrator getDefaultVibrator();
    public abstract Vibrator getVibrator(int p0);
    public abstract int[] getVibratorIds();
    public abstract void cancel();
    public final void vibrate(CombinedVibration p0){}
    public final void vibrate(CombinedVibration p0, VibrationAttributes p1){}
}
