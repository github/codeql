// Generated automatically from android.hardware.SensorManager for testing purposes

package android.hardware;

import android.hardware.HardwareBuffer;
import android.hardware.Sensor;
import android.hardware.SensorDirectChannel;
import android.hardware.SensorEventListener;
import android.hardware.SensorListener;
import android.hardware.TriggerEventListener;
import android.os.Handler;
import android.os.MemoryFile;
import java.util.List;

abstract public class SensorManager
{
    abstract static public class DynamicSensorCallback
    {
        public DynamicSensorCallback(){}
        public void onDynamicSensorConnected(Sensor p0){}
        public void onDynamicSensorDisconnected(Sensor p0){}
    }
    public List<Sensor> getDynamicSensorList(int p0){ return null; }
    public List<Sensor> getSensorList(int p0){ return null; }
    public Sensor getDefaultSensor(int p0){ return null; }
    public Sensor getDefaultSensor(int p0, boolean p1){ return null; }
    public SensorDirectChannel createDirectChannel(HardwareBuffer p0){ return null; }
    public SensorDirectChannel createDirectChannel(MemoryFile p0){ return null; }
    public boolean cancelTriggerSensor(TriggerEventListener p0, Sensor p1){ return false; }
    public boolean flush(SensorEventListener p0){ return false; }
    public boolean isDynamicSensorDiscoverySupported(){ return false; }
    public boolean registerListener(SensorEventListener p0, Sensor p1, int p2){ return false; }
    public boolean registerListener(SensorEventListener p0, Sensor p1, int p2, Handler p3){ return false; }
    public boolean registerListener(SensorEventListener p0, Sensor p1, int p2, int p3){ return false; }
    public boolean registerListener(SensorEventListener p0, Sensor p1, int p2, int p3, Handler p4){ return false; }
    public boolean registerListener(SensorListener p0, int p1){ return false; }
    public boolean registerListener(SensorListener p0, int p1, int p2){ return false; }
    public boolean requestTriggerSensor(TriggerEventListener p0, Sensor p1){ return false; }
    public int getSensors(){ return 0; }
    public static boolean getRotationMatrix(float[] p0, float[] p1, float[] p2, float[] p3){ return false; }
    public static boolean remapCoordinateSystem(float[] p0, int p1, int p2, float[] p3){ return false; }
    public static float GRAVITY_DEATH_STAR_I = 0;
    public static float GRAVITY_EARTH = 0;
    public static float GRAVITY_JUPITER = 0;
    public static float GRAVITY_MARS = 0;
    public static float GRAVITY_MERCURY = 0;
    public static float GRAVITY_MOON = 0;
    public static float GRAVITY_NEPTUNE = 0;
    public static float GRAVITY_PLUTO = 0;
    public static float GRAVITY_SATURN = 0;
    public static float GRAVITY_SUN = 0;
    public static float GRAVITY_THE_ISLAND = 0;
    public static float GRAVITY_URANUS = 0;
    public static float GRAVITY_VENUS = 0;
    public static float LIGHT_CLOUDY = 0;
    public static float LIGHT_FULLMOON = 0;
    public static float LIGHT_NO_MOON = 0;
    public static float LIGHT_OVERCAST = 0;
    public static float LIGHT_SHADE = 0;
    public static float LIGHT_SUNLIGHT = 0;
    public static float LIGHT_SUNLIGHT_MAX = 0;
    public static float LIGHT_SUNRISE = 0;
    public static float MAGNETIC_FIELD_EARTH_MAX = 0;
    public static float MAGNETIC_FIELD_EARTH_MIN = 0;
    public static float PRESSURE_STANDARD_ATMOSPHERE = 0;
    public static float STANDARD_GRAVITY = 0;
    public static float getAltitude(float p0, float p1){ return 0; }
    public static float getInclination(float[] p0){ return 0; }
    public static float[] getOrientation(float[] p0, float[] p1){ return null; }
    public static int AXIS_MINUS_X = 0;
    public static int AXIS_MINUS_Y = 0;
    public static int AXIS_MINUS_Z = 0;
    public static int AXIS_X = 0;
    public static int AXIS_Y = 0;
    public static int AXIS_Z = 0;
    public static int DATA_X = 0;
    public static int DATA_Y = 0;
    public static int DATA_Z = 0;
    public static int RAW_DATA_INDEX = 0;
    public static int RAW_DATA_X = 0;
    public static int RAW_DATA_Y = 0;
    public static int RAW_DATA_Z = 0;
    public static int SENSOR_ACCELEROMETER = 0;
    public static int SENSOR_ALL = 0;
    public static int SENSOR_DELAY_FASTEST = 0;
    public static int SENSOR_DELAY_GAME = 0;
    public static int SENSOR_DELAY_NORMAL = 0;
    public static int SENSOR_DELAY_UI = 0;
    public static int SENSOR_LIGHT = 0;
    public static int SENSOR_MAGNETIC_FIELD = 0;
    public static int SENSOR_MAX = 0;
    public static int SENSOR_MIN = 0;
    public static int SENSOR_ORIENTATION = 0;
    public static int SENSOR_ORIENTATION_RAW = 0;
    public static int SENSOR_PROXIMITY = 0;
    public static int SENSOR_STATUS_ACCURACY_HIGH = 0;
    public static int SENSOR_STATUS_ACCURACY_LOW = 0;
    public static int SENSOR_STATUS_ACCURACY_MEDIUM = 0;
    public static int SENSOR_STATUS_NO_CONTACT = 0;
    public static int SENSOR_STATUS_UNRELIABLE = 0;
    public static int SENSOR_TEMPERATURE = 0;
    public static int SENSOR_TRICORDER = 0;
    public static void getAngleChange(float[] p0, float[] p1, float[] p2){}
    public static void getQuaternionFromVector(float[] p0, float[] p1){}
    public static void getRotationMatrixFromVector(float[] p0, float[] p1){}
    public void registerDynamicSensorCallback(SensorManager.DynamicSensorCallback p0){}
    public void registerDynamicSensorCallback(SensorManager.DynamicSensorCallback p0, Handler p1){}
    public void unregisterDynamicSensorCallback(SensorManager.DynamicSensorCallback p0){}
    public void unregisterListener(SensorEventListener p0){}
    public void unregisterListener(SensorEventListener p0, Sensor p1){}
    public void unregisterListener(SensorListener p0){}
    public void unregisterListener(SensorListener p0, int p1){}
}
