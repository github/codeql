// Generated automatically from android.view.MotionEvent for testing purposes

package android.view;

import android.graphics.Matrix;
import android.os.Parcel;
import android.os.Parcelable;
import android.view.InputEvent;

public class MotionEvent extends InputEvent implements Parcelable
{
    protected MotionEvent() {}
    protected void finalize(){}
    public String toString(){ return null; }
    public boolean isButtonPressed(int p0){ return false; }
    public float getAxisValue(int p0){ return 0; }
    public float getAxisValue(int p0, int p1){ return 0; }
    public float getHistoricalAxisValue(int p0, int p1){ return 0; }
    public float getHistoricalAxisValue(int p0, int p1, int p2){ return 0; }
    public float getHistoricalOrientation(int p0){ return 0; }
    public float getHistoricalOrientation(int p0, int p1){ return 0; }
    public float getHistoricalPressure(int p0){ return 0; }
    public float getHistoricalPressure(int p0, int p1){ return 0; }
    public float getHistoricalSize(int p0){ return 0; }
    public float getHistoricalSize(int p0, int p1){ return 0; }
    public float getHistoricalToolMajor(int p0){ return 0; }
    public float getHistoricalToolMajor(int p0, int p1){ return 0; }
    public float getHistoricalToolMinor(int p0){ return 0; }
    public float getHistoricalToolMinor(int p0, int p1){ return 0; }
    public float getHistoricalTouchMajor(int p0){ return 0; }
    public float getHistoricalTouchMajor(int p0, int p1){ return 0; }
    public float getHistoricalTouchMinor(int p0){ return 0; }
    public float getHistoricalTouchMinor(int p0, int p1){ return 0; }
    public float getHistoricalX(int p0){ return 0; }
    public float getHistoricalX(int p0, int p1){ return 0; }
    public float getHistoricalY(int p0){ return 0; }
    public float getHistoricalY(int p0, int p1){ return 0; }
    public float getOrientation(){ return 0; }
    public float getOrientation(int p0){ return 0; }
    public float getPressure(){ return 0; }
    public float getPressure(int p0){ return 0; }
    public float getRawX(){ return 0; }
    public float getRawX(int p0){ return 0; }
    public float getRawY(){ return 0; }
    public float getRawY(int p0){ return 0; }
    public float getSize(){ return 0; }
    public float getSize(int p0){ return 0; }
    public float getToolMajor(){ return 0; }
    public float getToolMajor(int p0){ return 0; }
    public float getToolMinor(){ return 0; }
    public float getToolMinor(int p0){ return 0; }
    public float getTouchMajor(){ return 0; }
    public float getTouchMajor(int p0){ return 0; }
    public float getTouchMinor(){ return 0; }
    public float getTouchMinor(int p0){ return 0; }
    public float getX(){ return 0; }
    public float getX(int p0){ return 0; }
    public float getXPrecision(){ return 0; }
    public float getY(){ return 0; }
    public float getY(int p0){ return 0; }
    public float getYPrecision(){ return 0; }
    public int findPointerIndex(int p0){ return 0; }
    public int getAction(){ return 0; }
    public int getActionButton(){ return 0; }
    public int getActionIndex(){ return 0; }
    public int getActionMasked(){ return 0; }
    public int getButtonState(){ return 0; }
    public int getClassification(){ return 0; }
    public int getDeviceId(){ return 0; }
    public int getEdgeFlags(){ return 0; }
    public int getFlags(){ return 0; }
    public int getHistorySize(){ return 0; }
    public int getMetaState(){ return 0; }
    public int getPointerCount(){ return 0; }
    public int getPointerId(int p0){ return 0; }
    public int getSource(){ return 0; }
    public int getToolType(int p0){ return 0; }
    public long getDownTime(){ return 0; }
    public long getEventTime(){ return 0; }
    public long getHistoricalEventTime(int p0){ return 0; }
    public static MotionEvent obtain(MotionEvent p0){ return null; }
    public static MotionEvent obtain(long p0, long p1, int p2, float p3, float p4, float p5, float p6, int p7, float p8, float p9, int p10, int p11){ return null; }
    public static MotionEvent obtain(long p0, long p1, int p2, float p3, float p4, int p5){ return null; }
    public static MotionEvent obtain(long p0, long p1, int p2, int p3, MotionEvent.PointerProperties[] p4, MotionEvent.PointerCoords[] p5, int p6, int p7, float p8, float p9, int p10, int p11, int p12, int p13){ return null; }
    public static MotionEvent obtain(long p0, long p1, int p2, int p3, float p4, float p5, float p6, float p7, int p8, float p9, float p10, int p11, int p12){ return null; }
    public static MotionEvent obtain(long p0, long p1, int p2, int p3, int[] p4, MotionEvent.PointerCoords[] p5, int p6, float p7, float p8, int p9, int p10, int p11, int p12){ return null; }
    public static MotionEvent obtainNoHistory(MotionEvent p0){ return null; }
    public static Parcelable.Creator<MotionEvent> CREATOR = null;
    public static String actionToString(int p0){ return null; }
    public static String axisToString(int p0){ return null; }
    public static int ACTION_BUTTON_PRESS = 0;
    public static int ACTION_BUTTON_RELEASE = 0;
    public static int ACTION_CANCEL = 0;
    public static int ACTION_DOWN = 0;
    public static int ACTION_HOVER_ENTER = 0;
    public static int ACTION_HOVER_EXIT = 0;
    public static int ACTION_HOVER_MOVE = 0;
    public static int ACTION_MASK = 0;
    public static int ACTION_MOVE = 0;
    public static int ACTION_OUTSIDE = 0;
    public static int ACTION_POINTER_1_DOWN = 0;
    public static int ACTION_POINTER_1_UP = 0;
    public static int ACTION_POINTER_2_DOWN = 0;
    public static int ACTION_POINTER_2_UP = 0;
    public static int ACTION_POINTER_3_DOWN = 0;
    public static int ACTION_POINTER_3_UP = 0;
    public static int ACTION_POINTER_DOWN = 0;
    public static int ACTION_POINTER_ID_MASK = 0;
    public static int ACTION_POINTER_ID_SHIFT = 0;
    public static int ACTION_POINTER_INDEX_MASK = 0;
    public static int ACTION_POINTER_INDEX_SHIFT = 0;
    public static int ACTION_POINTER_UP = 0;
    public static int ACTION_SCROLL = 0;
    public static int ACTION_UP = 0;
    public static int AXIS_BRAKE = 0;
    public static int AXIS_DISTANCE = 0;
    public static int AXIS_GAS = 0;
    public static int AXIS_GENERIC_1 = 0;
    public static int AXIS_GENERIC_10 = 0;
    public static int AXIS_GENERIC_11 = 0;
    public static int AXIS_GENERIC_12 = 0;
    public static int AXIS_GENERIC_13 = 0;
    public static int AXIS_GENERIC_14 = 0;
    public static int AXIS_GENERIC_15 = 0;
    public static int AXIS_GENERIC_16 = 0;
    public static int AXIS_GENERIC_2 = 0;
    public static int AXIS_GENERIC_3 = 0;
    public static int AXIS_GENERIC_4 = 0;
    public static int AXIS_GENERIC_5 = 0;
    public static int AXIS_GENERIC_6 = 0;
    public static int AXIS_GENERIC_7 = 0;
    public static int AXIS_GENERIC_8 = 0;
    public static int AXIS_GENERIC_9 = 0;
    public static int AXIS_HAT_X = 0;
    public static int AXIS_HAT_Y = 0;
    public static int AXIS_HSCROLL = 0;
    public static int AXIS_LTRIGGER = 0;
    public static int AXIS_ORIENTATION = 0;
    public static int AXIS_PRESSURE = 0;
    public static int AXIS_RELATIVE_X = 0;
    public static int AXIS_RELATIVE_Y = 0;
    public static int AXIS_RTRIGGER = 0;
    public static int AXIS_RUDDER = 0;
    public static int AXIS_RX = 0;
    public static int AXIS_RY = 0;
    public static int AXIS_RZ = 0;
    public static int AXIS_SCROLL = 0;
    public static int AXIS_SIZE = 0;
    public static int AXIS_THROTTLE = 0;
    public static int AXIS_TILT = 0;
    public static int AXIS_TOOL_MAJOR = 0;
    public static int AXIS_TOOL_MINOR = 0;
    public static int AXIS_TOUCH_MAJOR = 0;
    public static int AXIS_TOUCH_MINOR = 0;
    public static int AXIS_VSCROLL = 0;
    public static int AXIS_WHEEL = 0;
    public static int AXIS_X = 0;
    public static int AXIS_Y = 0;
    public static int AXIS_Z = 0;
    public static int BUTTON_BACK = 0;
    public static int BUTTON_FORWARD = 0;
    public static int BUTTON_PRIMARY = 0;
    public static int BUTTON_SECONDARY = 0;
    public static int BUTTON_STYLUS_PRIMARY = 0;
    public static int BUTTON_STYLUS_SECONDARY = 0;
    public static int BUTTON_TERTIARY = 0;
    public static int CLASSIFICATION_AMBIGUOUS_GESTURE = 0;
    public static int CLASSIFICATION_DEEP_PRESS = 0;
    public static int CLASSIFICATION_NONE = 0;
    public static int EDGE_BOTTOM = 0;
    public static int EDGE_LEFT = 0;
    public static int EDGE_RIGHT = 0;
    public static int EDGE_TOP = 0;
    public static int FLAG_WINDOW_IS_OBSCURED = 0;
    public static int FLAG_WINDOW_IS_PARTIALLY_OBSCURED = 0;
    public static int INVALID_POINTER_ID = 0;
    public static int TOOL_TYPE_ERASER = 0;
    public static int TOOL_TYPE_FINGER = 0;
    public static int TOOL_TYPE_MOUSE = 0;
    public static int TOOL_TYPE_STYLUS = 0;
    public static int TOOL_TYPE_UNKNOWN = 0;
    public static int axisFromString(String p0){ return 0; }
    public void addBatch(long p0, MotionEvent.PointerCoords[] p1, int p2){}
    public void addBatch(long p0, float p1, float p2, float p3, float p4, int p5){}
    public void getHistoricalPointerCoords(int p0, int p1, MotionEvent.PointerCoords p2){}
    public void getPointerCoords(int p0, MotionEvent.PointerCoords p1){}
    public void getPointerProperties(int p0, MotionEvent.PointerProperties p1){}
    public void offsetLocation(float p0, float p1){}
    public void recycle(){}
    public void setAction(int p0){}
    public void setEdgeFlags(int p0){}
    public void setLocation(float p0, float p1){}
    public void setSource(int p0){}
    public void transform(Matrix p0){}
    public void writeToParcel(Parcel p0, int p1){}
    static public class PointerCoords
    {
        public PointerCoords(){}
        public PointerCoords(MotionEvent.PointerCoords p0){}
        public float getAxisValue(int p0){ return 0; }
        public float orientation = 0;
        public float pressure = 0;
        public float size = 0;
        public float toolMajor = 0;
        public float toolMinor = 0;
        public float touchMajor = 0;
        public float touchMinor = 0;
        public float x = 0;
        public float y = 0;
        public void clear(){}
        public void copyFrom(MotionEvent.PointerCoords p0){}
        public void setAxisValue(int p0, float p1){}
    }
    static public class PointerProperties
    {
        public PointerProperties(){}
        public PointerProperties(MotionEvent.PointerProperties p0){}
        public boolean equals(Object p0){ return false; }
        public int hashCode(){ return 0; }
        public int id = 0;
        public int toolType = 0;
        public void clear(){}
        public void copyFrom(MotionEvent.PointerProperties p0){}
    }
}
