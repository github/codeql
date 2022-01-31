// Generated automatically from android.view.accessibility.AccessibilityEvent for testing purposes

package android.view.accessibility;

import android.os.Parcel;
import android.os.Parcelable;
import android.view.accessibility.AccessibilityRecord;

public class AccessibilityEvent extends AccessibilityRecord implements Parcelable
{
    public AccessibilityEvent(){}
    public AccessibilityEvent(AccessibilityEvent p0){}
    public AccessibilityEvent(int p0){}
    public AccessibilityRecord getRecord(int p0){ return null; }
    public CharSequence getPackageName(){ return null; }
    public String toString(){ return null; }
    public int describeContents(){ return 0; }
    public int getAction(){ return 0; }
    public int getContentChangeTypes(){ return 0; }
    public int getEventType(){ return 0; }
    public int getMovementGranularity(){ return 0; }
    public int getRecordCount(){ return 0; }
    public int getWindowChanges(){ return 0; }
    public long getEventTime(){ return 0; }
    public static AccessibilityEvent obtain(){ return null; }
    public static AccessibilityEvent obtain(AccessibilityEvent p0){ return null; }
    public static AccessibilityEvent obtain(int p0){ return null; }
    public static Parcelable.Creator<AccessibilityEvent> CREATOR = null;
    public static String eventTypeToString(int p0){ return null; }
    public static int CONTENT_CHANGE_TYPE_CONTENT_DESCRIPTION = 0;
    public static int CONTENT_CHANGE_TYPE_PANE_APPEARED = 0;
    public static int CONTENT_CHANGE_TYPE_PANE_DISAPPEARED = 0;
    public static int CONTENT_CHANGE_TYPE_PANE_TITLE = 0;
    public static int CONTENT_CHANGE_TYPE_STATE_DESCRIPTION = 0;
    public static int CONTENT_CHANGE_TYPE_SUBTREE = 0;
    public static int CONTENT_CHANGE_TYPE_TEXT = 0;
    public static int CONTENT_CHANGE_TYPE_UNDEFINED = 0;
    public static int INVALID_POSITION = 0;
    public static int MAX_TEXT_LENGTH = 0;
    public static int TYPES_ALL_MASK = 0;
    public static int TYPE_ANNOUNCEMENT = 0;
    public static int TYPE_ASSIST_READING_CONTEXT = 0;
    public static int TYPE_GESTURE_DETECTION_END = 0;
    public static int TYPE_GESTURE_DETECTION_START = 0;
    public static int TYPE_NOTIFICATION_STATE_CHANGED = 0;
    public static int TYPE_TOUCH_EXPLORATION_GESTURE_END = 0;
    public static int TYPE_TOUCH_EXPLORATION_GESTURE_START = 0;
    public static int TYPE_TOUCH_INTERACTION_END = 0;
    public static int TYPE_TOUCH_INTERACTION_START = 0;
    public static int TYPE_VIEW_ACCESSIBILITY_FOCUSED = 0;
    public static int TYPE_VIEW_ACCESSIBILITY_FOCUS_CLEARED = 0;
    public static int TYPE_VIEW_CLICKED = 0;
    public static int TYPE_VIEW_CONTEXT_CLICKED = 0;
    public static int TYPE_VIEW_FOCUSED = 0;
    public static int TYPE_VIEW_HOVER_ENTER = 0;
    public static int TYPE_VIEW_HOVER_EXIT = 0;
    public static int TYPE_VIEW_LONG_CLICKED = 0;
    public static int TYPE_VIEW_SCROLLED = 0;
    public static int TYPE_VIEW_SELECTED = 0;
    public static int TYPE_VIEW_TEXT_CHANGED = 0;
    public static int TYPE_VIEW_TEXT_SELECTION_CHANGED = 0;
    public static int TYPE_VIEW_TEXT_TRAVERSED_AT_MOVEMENT_GRANULARITY = 0;
    public static int TYPE_WINDOWS_CHANGED = 0;
    public static int TYPE_WINDOW_CONTENT_CHANGED = 0;
    public static int TYPE_WINDOW_STATE_CHANGED = 0;
    public static int WINDOWS_CHANGE_ACCESSIBILITY_FOCUSED = 0;
    public static int WINDOWS_CHANGE_ACTIVE = 0;
    public static int WINDOWS_CHANGE_ADDED = 0;
    public static int WINDOWS_CHANGE_BOUNDS = 0;
    public static int WINDOWS_CHANGE_CHILDREN = 0;
    public static int WINDOWS_CHANGE_FOCUSED = 0;
    public static int WINDOWS_CHANGE_LAYER = 0;
    public static int WINDOWS_CHANGE_PARENT = 0;
    public static int WINDOWS_CHANGE_PIP = 0;
    public static int WINDOWS_CHANGE_REMOVED = 0;
    public static int WINDOWS_CHANGE_TITLE = 0;
    public void appendRecord(AccessibilityRecord p0){}
    public void initFromParcel(Parcel p0){}
    public void recycle(){}
    public void setAction(int p0){}
    public void setContentChangeTypes(int p0){}
    public void setEventTime(long p0){}
    public void setEventType(int p0){}
    public void setMovementGranularity(int p0){}
    public void setPackageName(CharSequence p0){}
    public void writeToParcel(Parcel p0, int p1){}
}
