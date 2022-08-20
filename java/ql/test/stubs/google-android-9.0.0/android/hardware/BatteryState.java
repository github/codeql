// Generated automatically from android.hardware.BatteryState for testing purposes

package android.hardware;


abstract public class BatteryState
{
    public BatteryState(){}
    public abstract boolean isPresent();
    public abstract float getCapacity();
    public abstract int getStatus();
    public static int STATUS_CHARGING = 0;
    public static int STATUS_DISCHARGING = 0;
    public static int STATUS_FULL = 0;
    public static int STATUS_NOT_CHARGING = 0;
    public static int STATUS_UNKNOWN = 0;
}
