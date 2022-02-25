// Generated automatically from android.view.InputDevice for testing purposes

package android.view;

import android.hardware.BatteryState;
import android.hardware.SensorManager;
import android.hardware.lights.LightsManager;
import android.os.Parcel;
import android.os.Parcelable;
import android.os.Vibrator;
import android.os.VibratorManager;
import android.view.KeyCharacterMap;
import java.util.List;

public class InputDevice implements Parcelable
{
    public BatteryState getBatteryState(){ return null; }
    public InputDevice.MotionRange getMotionRange(int p0){ return null; }
    public InputDevice.MotionRange getMotionRange(int p0, int p1){ return null; }
    public KeyCharacterMap getKeyCharacterMap(){ return null; }
    public LightsManager getLightsManager(){ return null; }
    public List<InputDevice.MotionRange> getMotionRanges(){ return null; }
    public SensorManager getSensorManager(){ return null; }
    public String getDescriptor(){ return null; }
    public String getName(){ return null; }
    public String toString(){ return null; }
    public Vibrator getVibrator(){ return null; }
    public VibratorManager getVibratorManager(){ return null; }
    public boolean hasMicrophone(){ return false; }
    public boolean isEnabled(){ return false; }
    public boolean isExternal(){ return false; }
    public boolean isVirtual(){ return false; }
    public boolean supportsSource(int p0){ return false; }
    public boolean[] hasKeys(int... p0){ return null; }
    public int describeContents(){ return 0; }
    public int getControllerNumber(){ return 0; }
    public int getId(){ return 0; }
    public int getKeyboardType(){ return 0; }
    public int getProductId(){ return 0; }
    public int getSources(){ return 0; }
    public int getVendorId(){ return 0; }
    public static InputDevice getDevice(int p0){ return null; }
    public static Parcelable.Creator<InputDevice> CREATOR = null;
    public static int KEYBOARD_TYPE_ALPHABETIC = 0;
    public static int KEYBOARD_TYPE_NONE = 0;
    public static int KEYBOARD_TYPE_NON_ALPHABETIC = 0;
    public static int MOTION_RANGE_ORIENTATION = 0;
    public static int MOTION_RANGE_PRESSURE = 0;
    public static int MOTION_RANGE_SIZE = 0;
    public static int MOTION_RANGE_TOOL_MAJOR = 0;
    public static int MOTION_RANGE_TOOL_MINOR = 0;
    public static int MOTION_RANGE_TOUCH_MAJOR = 0;
    public static int MOTION_RANGE_TOUCH_MINOR = 0;
    public static int MOTION_RANGE_X = 0;
    public static int MOTION_RANGE_Y = 0;
    public static int SOURCE_ANY = 0;
    public static int SOURCE_BLUETOOTH_STYLUS = 0;
    public static int SOURCE_CLASS_BUTTON = 0;
    public static int SOURCE_CLASS_JOYSTICK = 0;
    public static int SOURCE_CLASS_MASK = 0;
    public static int SOURCE_CLASS_NONE = 0;
    public static int SOURCE_CLASS_POINTER = 0;
    public static int SOURCE_CLASS_POSITION = 0;
    public static int SOURCE_CLASS_TRACKBALL = 0;
    public static int SOURCE_DPAD = 0;
    public static int SOURCE_GAMEPAD = 0;
    public static int SOURCE_HDMI = 0;
    public static int SOURCE_JOYSTICK = 0;
    public static int SOURCE_KEYBOARD = 0;
    public static int SOURCE_MOUSE = 0;
    public static int SOURCE_MOUSE_RELATIVE = 0;
    public static int SOURCE_ROTARY_ENCODER = 0;
    public static int SOURCE_SENSOR = 0;
    public static int SOURCE_STYLUS = 0;
    public static int SOURCE_TOUCHPAD = 0;
    public static int SOURCE_TOUCHSCREEN = 0;
    public static int SOURCE_TOUCH_NAVIGATION = 0;
    public static int SOURCE_TRACKBALL = 0;
    public static int SOURCE_UNKNOWN = 0;
    public static int[] getDeviceIds(){ return null; }
    public void writeToParcel(Parcel p0, int p1){}
    static public class MotionRange
    {
        protected MotionRange() {}
        public boolean isFromSource(int p0){ return false; }
        public float getFlat(){ return 0; }
        public float getFuzz(){ return 0; }
        public float getMax(){ return 0; }
        public float getMin(){ return 0; }
        public float getRange(){ return 0; }
        public float getResolution(){ return 0; }
        public int getAxis(){ return 0; }
        public int getSource(){ return 0; }
    }
}
