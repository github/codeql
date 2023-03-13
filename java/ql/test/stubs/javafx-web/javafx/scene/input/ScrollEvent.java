// Generated automatically from javafx.scene.input.ScrollEvent for testing purposes

package javafx.scene.input;

import javafx.event.Event;
import javafx.event.EventTarget;
import javafx.event.EventType;
import javafx.scene.input.GestureEvent;
import javafx.scene.input.PickResult;

public class ScrollEvent extends GestureEvent
{
    protected ScrollEvent() {}
    public EventType<ScrollEvent> getEventType(){ return null; }
    public ScrollEvent copyFor(Object p0, EventTarget p1){ return null; }
    public ScrollEvent copyFor(Object p0, EventTarget p1, EventType<ScrollEvent> p2){ return null; }
    public ScrollEvent(EventType<ScrollEvent> p0, double p1, double p2, double p3, double p4, boolean p5, boolean p6, boolean p7, boolean p8, boolean p9, boolean p10, double p11, double p12, double p13, double p14, ScrollEvent.HorizontalTextScrollUnits p15, double p16, ScrollEvent.VerticalTextScrollUnits p17, double p18, int p19, PickResult p20){}
    public ScrollEvent(EventType<ScrollEvent> p0, double p1, double p2, double p3, double p4, boolean p5, boolean p6, boolean p7, boolean p8, boolean p9, boolean p10, double p11, double p12, double p13, double p14, double p15, double p16, ScrollEvent.HorizontalTextScrollUnits p17, double p18, ScrollEvent.VerticalTextScrollUnits p19, double p20, int p21, PickResult p22){}
    public ScrollEvent(Object p0, EventTarget p1, EventType<ScrollEvent> p2, double p3, double p4, double p5, double p6, boolean p7, boolean p8, boolean p9, boolean p10, boolean p11, boolean p12, double p13, double p14, double p15, double p16, ScrollEvent.HorizontalTextScrollUnits p17, double p18, ScrollEvent.VerticalTextScrollUnits p19, double p20, int p21, PickResult p22){}
    public ScrollEvent.HorizontalTextScrollUnits getTextDeltaXUnits(){ return null; }
    public ScrollEvent.VerticalTextScrollUnits getTextDeltaYUnits(){ return null; }
    public String toString(){ return null; }
    public double getDeltaX(){ return 0; }
    public double getDeltaY(){ return 0; }
    public double getMultiplierX(){ return 0; }
    public double getMultiplierY(){ return 0; }
    public double getTextDeltaX(){ return 0; }
    public double getTextDeltaY(){ return 0; }
    public double getTotalDeltaX(){ return 0; }
    public double getTotalDeltaY(){ return 0; }
    public int getTouchCount(){ return 0; }
    public static EventType<ScrollEvent> ANY = null;
    public static EventType<ScrollEvent> SCROLL = null;
    public static EventType<ScrollEvent> SCROLL_FINISHED = null;
    public static EventType<ScrollEvent> SCROLL_STARTED = null;
    static public enum HorizontalTextScrollUnits
    {
        CHARACTERS, NONE;
        private HorizontalTextScrollUnits() {}
    }
    static public enum VerticalTextScrollUnits
    {
        LINES, NONE, PAGES;
        private VerticalTextScrollUnits() {}
    }
}
