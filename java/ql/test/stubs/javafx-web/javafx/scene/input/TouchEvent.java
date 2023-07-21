// Generated automatically from javafx.scene.input.TouchEvent for testing purposes

package javafx.scene.input;

import java.util.List;
import javafx.event.Event;
import javafx.event.EventTarget;
import javafx.event.EventType;
import javafx.scene.input.InputEvent;
import javafx.scene.input.TouchPoint;

public class TouchEvent extends InputEvent
{
    protected TouchEvent() {}
    public EventType<TouchEvent> getEventType(){ return null; }
    public List<TouchPoint> getTouchPoints(){ return null; }
    public String toString(){ return null; }
    public TouchEvent copyFor(Object p0, EventTarget p1){ return null; }
    public TouchEvent copyFor(Object p0, EventTarget p1, EventType<TouchEvent> p2){ return null; }
    public TouchEvent(EventType<TouchEvent> p0, TouchPoint p1, List<TouchPoint> p2, int p3, boolean p4, boolean p5, boolean p6, boolean p7){}
    public TouchEvent(Object p0, EventTarget p1, EventType<TouchEvent> p2, TouchPoint p3, List<TouchPoint> p4, int p5, boolean p6, boolean p7, boolean p8, boolean p9){}
    public TouchPoint getTouchPoint(){ return null; }
    public final boolean isAltDown(){ return false; }
    public final boolean isControlDown(){ return false; }
    public final boolean isMetaDown(){ return false; }
    public final boolean isShiftDown(){ return false; }
    public final int getEventSetId(){ return 0; }
    public int getTouchCount(){ return 0; }
    public static EventType<TouchEvent> ANY = null;
    public static EventType<TouchEvent> TOUCH_MOVED = null;
    public static EventType<TouchEvent> TOUCH_PRESSED = null;
    public static EventType<TouchEvent> TOUCH_RELEASED = null;
    public static EventType<TouchEvent> TOUCH_STATIONARY = null;
}
