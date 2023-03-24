// Generated automatically from android.view.textclassifier.SelectionEvent for testing purposes

package android.view.textclassifier;

import android.os.Parcel;
import android.os.Parcelable;
import android.view.textclassifier.TextClassification;
import android.view.textclassifier.TextClassificationSessionId;
import android.view.textclassifier.TextSelection;

public class SelectionEvent implements Parcelable
{
    public String getEntityType(){ return null; }
    public String getPackageName(){ return null; }
    public String getResultId(){ return null; }
    public String getWidgetType(){ return null; }
    public String getWidgetVersion(){ return null; }
    public String toString(){ return null; }
    public TextClassificationSessionId getSessionId(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int describeContents(){ return 0; }
    public int getEnd(){ return 0; }
    public int getEventIndex(){ return 0; }
    public int getEventType(){ return 0; }
    public int getInvocationMethod(){ return 0; }
    public int getSmartEnd(){ return 0; }
    public int getSmartStart(){ return 0; }
    public int getStart(){ return 0; }
    public int hashCode(){ return 0; }
    public long getDurationSincePreviousEvent(){ return 0; }
    public long getDurationSinceSessionStart(){ return 0; }
    public long getEventTime(){ return 0; }
    public static Parcelable.Creator<SelectionEvent> CREATOR = null;
    public static SelectionEvent createSelectionActionEvent(int p0, int p1, int p2){ return null; }
    public static SelectionEvent createSelectionActionEvent(int p0, int p1, int p2, TextClassification p3){ return null; }
    public static SelectionEvent createSelectionModifiedEvent(int p0, int p1){ return null; }
    public static SelectionEvent createSelectionModifiedEvent(int p0, int p1, TextClassification p2){ return null; }
    public static SelectionEvent createSelectionModifiedEvent(int p0, int p1, TextSelection p2){ return null; }
    public static SelectionEvent createSelectionStartedEvent(int p0, int p1){ return null; }
    public static boolean isTerminal(int p0){ return false; }
    public static int ACTION_ABANDON = 0;
    public static int ACTION_COPY = 0;
    public static int ACTION_CUT = 0;
    public static int ACTION_DRAG = 0;
    public static int ACTION_OTHER = 0;
    public static int ACTION_OVERTYPE = 0;
    public static int ACTION_PASTE = 0;
    public static int ACTION_RESET = 0;
    public static int ACTION_SELECT_ALL = 0;
    public static int ACTION_SHARE = 0;
    public static int ACTION_SMART_SHARE = 0;
    public static int EVENT_AUTO_SELECTION = 0;
    public static int EVENT_SELECTION_MODIFIED = 0;
    public static int EVENT_SELECTION_STARTED = 0;
    public static int EVENT_SMART_SELECTION_MULTI = 0;
    public static int EVENT_SMART_SELECTION_SINGLE = 0;
    public static int INVOCATION_LINK = 0;
    public static int INVOCATION_MANUAL = 0;
    public static int INVOCATION_UNKNOWN = 0;
    public void writeToParcel(Parcel p0, int p1){}
}
