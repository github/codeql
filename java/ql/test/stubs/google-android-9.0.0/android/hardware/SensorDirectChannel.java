// Generated automatically from android.hardware.SensorDirectChannel for testing purposes

package android.hardware;

import android.hardware.Sensor;
import java.nio.channels.Channel;

public class SensorDirectChannel implements Channel
{
    protected void finalize(){}
    public boolean isOpen(){ return false; }
    public int configure(Sensor p0, int p1){ return 0; }
    public static int RATE_FAST = 0;
    public static int RATE_NORMAL = 0;
    public static int RATE_STOP = 0;
    public static int RATE_VERY_FAST = 0;
    public static int TYPE_HARDWARE_BUFFER = 0;
    public static int TYPE_MEMORY_FILE = 0;
    public void close(){}
}
