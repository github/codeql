// Generated automatically from android.os.CombinedVibration for testing purposes

package android.os;

import android.os.Parcelable;
import android.os.VibrationEffect;

abstract public class CombinedVibration implements Parcelable
{
    public int describeContents(){ return 0; }
    public static CombinedVibration createParallel(VibrationEffect p0){ return null; }
    public static CombinedVibration.ParallelCombination startParallel(){ return null; }
    public static Parcelable.Creator<CombinedVibration> CREATOR = null;
    static public class ParallelCombination
    {
        public CombinedVibration combine(){ return null; }
        public CombinedVibration.ParallelCombination addVibrator(int p0, VibrationEffect p1){ return null; }
    }
}
