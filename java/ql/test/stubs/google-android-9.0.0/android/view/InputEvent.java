// Generated automatically from android.view.InputEvent for testing purposes

package android.view;

import android.os.Parcelable;
import android.view.InputDevice;

abstract public class InputEvent implements Parcelable
{
    public abstract int getDeviceId();
    public abstract int getSource();
    public abstract long getEventTime();
    public boolean isFromSource(int p0){ return false; }
    public final InputDevice getDevice(){ return null; }
    public int describeContents(){ return 0; }
    public static Parcelable.Creator<InputEvent> CREATOR = null;
}
